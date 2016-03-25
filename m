Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbcCYKol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 13/54] v4l: vsp1: Store the display list manager in the WPF
Date: Fri, 25 Mar 2016 12:43:47 +0200
Message-Id: <1458902668-1141-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each WPF can process display lists independently, move the manager to
the WPF to reflect that and prepare for display list support for non-DRM
pipelines.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c     | 37 ++++++++++++++++++++++++++-----
 drivers/media/platform/vsp1/vsp1_dl.h     | 26 ++++------------------
 drivers/media/platform/vsp1/vsp1_drm.c    | 19 +++++++---------
 drivers/media/platform/vsp1/vsp1_drm.h    |  8 +------
 drivers/media/platform/vsp1/vsp1_entity.c |  2 ++
 drivers/media/platform/vsp1/vsp1_entity.h |  2 ++
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  3 +++
 drivers/media/platform/vsp1/vsp1_wpf.c    | 18 +++++++++++++++
 8 files changed, 70 insertions(+), 45 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 72fb667814eb..0b2896c04f4f 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -48,6 +48,25 @@ struct vsp1_dl_list {
 	int reg_count;
 };
 
+/**
+ * struct vsp1_dl_manager - Display List manager
+ * @vsp1: the VSP1 device
+ * @lock: protects the active, queued and pending lists
+ * @free: array of all free display lists
+ * @active: list currently being processed (loaded) by hardware
+ * @queued: list queued to the hardware (written to the DL registers)
+ * @pending: list waiting to be queued to the hardware
+ */
+struct vsp1_dl_manager {
+	struct vsp1_device *vsp1;
+
+	spinlock_t lock;
+	struct list_head free;
+	struct vsp1_dl_list *active;
+	struct vsp1_dl_list *queued;
+	struct vsp1_dl_list *pending;
+};
+
 /* -----------------------------------------------------------------------------
  * Display List Transaction Management
  */
@@ -257,11 +276,16 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 	dlm->pending = NULL;
 }
 
-int vsp1_dlm_init(struct vsp1_device *vsp1, struct vsp1_dl_manager *dlm,
-		  unsigned int prealloc)
+struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
+					unsigned int prealloc)
 {
+	struct vsp1_dl_manager *dlm;
 	unsigned int i;
 
+	dlm = devm_kzalloc(vsp1->dev, sizeof(*dlm), GFP_KERNEL);
+	if (!dlm)
+		return NULL;
+
 	dlm->vsp1 = vsp1;
 
 	spin_lock_init(&dlm->lock);
@@ -272,18 +296,21 @@ int vsp1_dlm_init(struct vsp1_device *vsp1, struct vsp1_dl_manager *dlm,
 
 		dl = vsp1_dl_list_alloc(dlm);
 		if (!dl)
-			return -ENOMEM;
+			return NULL;
 
 		list_add_tail(&dl->list, &dlm->free);
 	}
 
-	return 0;
+	return dlm;
 }
 
-void vsp1_dlm_cleanup(struct vsp1_dl_manager *dlm)
+void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_dl_list *dl, *next;
 
+	if (!dlm)
+		return;
+
 	list_for_each_entry_safe(dl, next, &dlm->free, list) {
 		list_del(&dl->list);
 		vsp1_dl_list_free(dl);
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index caa6a85f6825..46f7ae337374 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -17,31 +17,13 @@
 
 struct vsp1_device;
 struct vsp1_dl_list;
-
-/**
- * struct vsp1_dl_manager - Display List manager
- * @vsp1: the VSP1 device
- * @lock: protects the active, queued and pending lists
- * @free: array of all free display lists
- * @active: list currently being processed (loaded) by hardware
- * @queued: list queued to the hardware (written to the DL registers)
- * @pending: list waiting to be queued to the hardware
- */
-struct vsp1_dl_manager {
-	struct vsp1_device *vsp1;
-
-	spinlock_t lock;
-	struct list_head free;
-	struct vsp1_dl_list *active;
-	struct vsp1_dl_list *queued;
-	struct vsp1_dl_list *pending;
-};
+struct vsp1_dl_manager;
 
 void vsp1_dlm_setup(struct vsp1_device *vsp1);
 
-int vsp1_dlm_init(struct vsp1_device *vsp1, struct vsp1_dl_manager *dlm,
-		  unsigned int prealloc);
-void vsp1_dlm_cleanup(struct vsp1_dl_manager *dlm);
+struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
+					unsigned int prealloc);
+void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a8cd74335f20..22f67360b750 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -31,11 +31,14 @@
  * Interrupt Handling
  */
 
-void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
+void vsp1_drm_display_start(struct vsp1_device *vsp1)
 {
-	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
+}
 
-	vsp1_dlm_irq_frame_end(&vsp1->drm->dlm);
+void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
+{
+	vsp1_dlm_irq_frame_end(pipe->output->dlm);
 }
 
 /* -----------------------------------------------------------------------------
@@ -101,7 +104,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 
 		pipe->num_inputs = 0;
 
-		vsp1_dlm_reset(&vsp1->drm->dlm);
+		vsp1_dlm_reset(pipe->output->dlm);
 		vsp1_device_put(vsp1);
 
 		dev_dbg(vsp1->dev, "%s: pipeline disabled\n", __func__);
@@ -228,7 +231,7 @@ void vsp1_du_atomic_begin(struct device *dev)
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
 	/* Prepare the display list. */
-	pipe->dl = vsp1_dl_list_get(&vsp1->drm->dlm);
+	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
@@ -555,16 +558,11 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 {
 	struct vsp1_pipeline *pipe;
 	unsigned int i;
-	int ret;
 
 	vsp1->drm = devm_kzalloc(vsp1->dev, sizeof(*vsp1->drm), GFP_KERNEL);
 	if (!vsp1->drm)
 		return -ENOMEM;
 
-	ret = vsp1_dlm_init(vsp1, &vsp1->drm->dlm, 4);
-	if (ret < 0)
-		return ret;
-
 	pipe = &vsp1->drm->pipe;
 
 	vsp1_pipeline_init(pipe);
@@ -590,5 +588,4 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 
 void vsp1_drm_cleanup(struct vsp1_device *vsp1)
 {
-	vsp1_dlm_cleanup(&vsp1->drm->dlm);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 5ef32cff9601..e9242f2c870e 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -13,7 +13,6 @@
 #ifndef __VSP1_DRM_H__
 #define __VSP1_DRM_H__
 
-#include "vsp1_dl.h"
 #include "vsp1_pipe.h"
 
 /**
@@ -21,22 +20,17 @@
  * @pipe: the VSP1 pipeline used for display
  * @num_inputs: number of active pipeline inputs at the beginning of an update
  * @update: the pipeline configuration has been updated
- * @dlm: display list manager used for DRM operation
  */
 struct vsp1_drm {
 	struct vsp1_pipeline pipe;
 	unsigned int num_inputs;
 	bool update;
-	struct vsp1_dl_manager dlm;
 };
 
 int vsp1_drm_init(struct vsp1_device *vsp1);
 void vsp1_drm_cleanup(struct vsp1_device *vsp1);
 int vsp1_drm_create_links(struct vsp1_device *vsp1);
 
-static inline void vsp1_drm_display_start(struct vsp1_device *vsp1)
-{
-	vsp1_dlm_irq_display_start(&vsp1->drm->dlm);
-}
+void vsp1_drm_display_start(struct vsp1_device *vsp1);
 
 #endif /* __VSP1_DRM_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 83689588900a..a94f544dcc77 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -244,6 +244,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 
 void vsp1_entity_destroy(struct vsp1_entity *entity)
 {
+	if (entity->destroy)
+		entity->destroy(entity);
 	if (entity->subdev.ctrl_handler)
 		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
 	media_entity_cleanup(&entity->subdev.entity);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 311d5b64c9a5..259880e524fe 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -56,6 +56,8 @@ struct vsp1_route {
 struct vsp1_entity {
 	struct vsp1_device *vsp1;
 
+	void (*destroy)(struct vsp1_entity *);
+
 	enum vsp1_entity_type type;
 	unsigned int index;
 	const struct vsp1_route *route;
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 8e8235682ada..d04df39b2737 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -24,6 +24,7 @@
 #define RWPF_PAD_SOURCE				1
 
 struct v4l2_ctrl;
+struct vsp1_dl_manager;
 struct vsp1_rwpf;
 struct vsp1_video;
 
@@ -60,6 +61,8 @@ struct vsp1_rwpf {
 
 	unsigned int offsets[2];
 	dma_addr_t buf_addr[3];
+
+	struct vsp1_dl_manager *dlm;
 };
 
 static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d2735f09d1da..3640989b3fd5 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
@@ -218,6 +219,13 @@ static const struct vsp1_rwpf_operations wpf_vdev_ops = {
  * Initialization and Cleanup
  */
 
+static void vsp1_wpf_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_rwpf *wpf = container_of(entity, struct vsp1_rwpf, entity);
+
+	vsp1_dlm_destroy(wpf->dlm);
+}
+
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 {
 	struct v4l2_subdev *subdev;
@@ -233,6 +241,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	wpf->max_width = WPF_MAX_WIDTH;
 	wpf->max_height = WPF_MAX_HEIGHT;
 
+	wpf->entity.destroy = vsp1_wpf_destroy;
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
 
@@ -240,6 +249,15 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/* Initialize the display list manager if the WPF is used for display */
+	if ((vsp1->info->features & VSP1_HAS_LIF) && index == 0) {
+		wpf->dlm = vsp1_dlm_create(vsp1, 4);
+		if (!wpf->dlm) {
+			ret = -ENOMEM;
+			goto error;
+		}
+	}
+
 	/* Initialize the V4L2 subdev. */
 	subdev = &wpf->entity.subdev;
 	v4l2_subdev_init(subdev, &wpf_ops);
-- 
2.7.3

