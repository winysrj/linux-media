Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbcCXX2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:17 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 26/51] v4l: vsp1: Consolidate entity ops in a struct vsp1_entity_operations
Date: Fri, 25 Mar 2016 01:27:22 +0200
Message-Id: <1458862067-19525-27-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Entities have two operations, a destroy operation stored directly in
vsp1_entity and a set_memory operation stored in a vsp1_rwpf_operations
structure. Move the two to a more generic vsp1_entity_operations
structure that will serve to implement additional operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c |  4 ++--
 drivers/media/platform/vsp1/vsp1_entity.h | 14 +++++++++++++-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 11 ++++++-----
 drivers/media/platform/vsp1/vsp1_rwpf.h   | 18 ++++++------------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 27 ++++++++++++++-------------
 5 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index dcb331fb5549..f09a54b396ec 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -223,8 +223,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 
 void vsp1_entity_destroy(struct vsp1_entity *entity)
 {
-	if (entity->destroy)
-		entity->destroy(entity);
+	if (entity->ops && entity->ops->destroy)
+		entity->ops->destroy(entity);
 	if (entity->subdev.ctrl_handler)
 		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
 	media_entity_cleanup(&entity->subdev.entity);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 056391105ee5..f46ba20c30b1 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -53,10 +53,22 @@ struct vsp1_route {
 	unsigned int inputs[VSP1_ENTITY_MAX_INPUTS];
 };
 
+/**
+ * struct vsp1_entity_operations - Entity operations
+ * @destroy:	Destroy the entity.
+ * @set_memory:	Setup memory buffer access. This operation applies the settings
+ *		stored in the rwpf mem field to the hardware. Valid for RPF and
+ *		WPF only.
+ */
+struct vsp1_entity_operations {
+	void (*destroy)(struct vsp1_entity *);
+	void (*set_memory)(struct vsp1_entity *);
+};
+
 struct vsp1_entity {
 	struct vsp1_device *vsp1;
 
-	void (*destroy)(struct vsp1_entity *);
+	const struct vsp1_entity_operations *ops;
 
 	enum vsp1_entity_type type;
 	unsigned int index;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index d9cc9b8fc0b6..5c84a92c975c 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -141,11 +141,13 @@ static struct v4l2_subdev_ops rpf_ops = {
 };
 
 /* -----------------------------------------------------------------------------
- * Video Device Operations
+ * VSP1 Entity Operations
  */
 
-static void rpf_set_memory(struct vsp1_rwpf *rpf)
+static void rpf_set_memory(struct vsp1_entity *entity)
 {
+	struct vsp1_rwpf *rpf = entity_to_rwpf(entity);
+
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
 		       rpf->mem.addr[0] + rpf->offsets[0]);
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
@@ -154,7 +156,7 @@ static void rpf_set_memory(struct vsp1_rwpf *rpf)
 		       rpf->mem.addr[2] + rpf->offsets[1]);
 }
 
-static const struct vsp1_rwpf_operations rpf_vdev_ops = {
+static const struct vsp1_entity_operations rpf_entity_ops = {
 	.set_memory = rpf_set_memory,
 };
 
@@ -172,11 +174,10 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (rpf == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	rpf->ops = &rpf_vdev_ops;
-
 	rpf->max_width = RPF_MAX_WIDTH;
 	rpf->max_height = RPF_MAX_HEIGHT;
 
+	rpf->entity.ops = &rpf_entity_ops;
 	rpf->entity.type = VSP1_ENTITY_RPF;
 	rpf->entity.index = index;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 2bbcc331959b..e8ca9b6ee689 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -32,23 +32,12 @@ struct vsp1_rwpf_memory {
 	dma_addr_t addr[3];
 };
 
-/**
- * struct vsp1_rwpf_operations - RPF and WPF operations
- * @set_memory: Setup memory buffer access. This operation applies the settings
- *		stored in the rwpf mem field to the hardware.
- */
-struct vsp1_rwpf_operations {
-	void (*set_memory)(struct vsp1_rwpf *rwpf);
-};
-
 struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct v4l2_ctrl_handler ctrls;
 
 	struct vsp1_video *video;
 
-	const struct vsp1_rwpf_operations *ops;
-
 	unsigned int max_width;
 	unsigned int max_height;
 
@@ -73,6 +62,11 @@ static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
 	return container_of(subdev, struct vsp1_rwpf, entity.subdev);
 }
 
+static inline struct vsp1_rwpf *entity_to_rwpf(struct vsp1_entity *entity)
+{
+	return container_of(entity, struct vsp1_rwpf, entity);
+}
+
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
@@ -105,7 +99,7 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
  */
 static inline void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf)
 {
-	rwpf->ops->set_memory(rwpf);
+	rwpf->entity.ops->set_memory(&rwpf->entity);
 }
 
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index f4861a2d2002..8cc19ef49f45 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -152,17 +152,27 @@ static struct v4l2_subdev_ops wpf_ops = {
 };
 
 /* -----------------------------------------------------------------------------
- * Video Device Operations
+ * VSP1 Entity Operations
  */
 
-static void wpf_set_memory(struct vsp1_rwpf *wpf)
+static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 {
+	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+
+	vsp1_dlm_destroy(wpf->dlm);
+}
+
+static void wpf_set_memory(struct vsp1_entity *entity)
+{
+	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
 }
 
-static const struct vsp1_rwpf_operations wpf_vdev_ops = {
+static const struct vsp1_entity_operations wpf_entity_ops = {
+	.destroy = vsp1_wpf_destroy,
 	.set_memory = wpf_set_memory,
 };
 
@@ -170,13 +180,6 @@ static const struct vsp1_rwpf_operations wpf_vdev_ops = {
  * Initialization and Cleanup
  */
 
-static void vsp1_wpf_destroy(struct vsp1_entity *entity)
-{
-	struct vsp1_rwpf *wpf = container_of(entity, struct vsp1_rwpf, entity);
-
-	vsp1_dlm_destroy(wpf->dlm);
-}
-
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 {
 	struct vsp1_rwpf *wpf;
@@ -187,12 +190,10 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (wpf == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	wpf->ops = &wpf_vdev_ops;
-
 	wpf->max_width = WPF_MAX_WIDTH;
 	wpf->max_height = WPF_MAX_HEIGHT;
 
-	wpf->entity.destroy = vsp1_wpf_destroy;
+	wpf->entity.ops = &wpf_entity_ops;
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
 
-- 
2.7.3

