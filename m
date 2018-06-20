Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43968 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932184AbeFTToZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 15:44:25 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/2] media: add helpers for memory-to-memory media controller
Date: Wed, 20 Jun 2018 16:44:05 -0300
Message-Id: <20180620194406.21753-2-ezequiel@collabora.com>
In-Reply-To: <20180620194406.21753-1-ezequiel@collabora.com>
References: <20180620194406.21753-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A memory-to-memory pipeline device consists in three
entities: two DMA engine and one video processing entities.
The DMA engine entities are linked to a V4L interface.

This commit add a new v4l2_m2m_{un}register_media_controller
API to register this topology.

For instance, a typical mem2mem device topology would
look like this:

Device topology
- entity 1: source (1 pad, 1 link)
            type Node subtype V4L flags 0
	pad0: Source
		<- "proc":0 [ENABLED,IMMUTABLE]

- entity 3: proc (2 pads, 2 links)
            type Node subtype Unknown flags 0
	pad0: Source
		-> "source":0 [ENABLED,IMMUTABLE]
	pad1: Sink
		<- "sink":0 [ENABLED,IMMUTABLE]

- entity 6: sink (1 pad, 1 link)
            type Node subtype V4L flags 0
	pad0: Sink
		-> "proc":1 [ENABLED,IMMUTABLE]

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c | 176 +++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |   5 +
 include/uapi/linux/media.h             |   3 +
 4 files changed, 192 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 4ffd7d60a901..c1996d73ca74 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -202,7 +202,7 @@ static void v4l2_device_release(struct device *cd)
 	mutex_unlock(&videodev_lock);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev->mdev) {
+	if (v4l2_dev->mdev && vdev->vfl_dir != VFL_DIR_M2M) {
 		/* Remove interfaces and interface links */
 		media_devnode_remove(vdev->intf_devnode);
 		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
@@ -733,19 +733,22 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			BASE_VIDIOC_PRIVATE);
 }
 
-static int video_register_media_controller(struct video_device *vdev, int type)
+static int video_register_media_controller(struct video_device *vdev)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	u32 intf_type;
 	int ret;
 
-	if (!vdev->v4l2_dev->mdev)
+	/* Memory-to-memory devices are more complex and use
+	 * their own function to register its mc entities.
+	 */
+	if (!vdev->v4l2_dev->mdev || vdev->vfl_dir == VFL_DIR_M2M)
 		return 0;
 
 	vdev->entity.obj_type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
 	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
 
-	switch (type) {
+	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
 		intf_type = MEDIA_INTF_T_V4L_VIDEO;
 		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
@@ -993,7 +996,7 @@ int __video_register_device(struct video_device *vdev,
 	v4l2_device_get(vdev->v4l2_dev);
 
 	/* Part 5: Register the entity. */
-	ret = video_register_media_controller(vdev, type);
+	ret = video_register_media_controller(vdev);
 
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index c4f963d96a79..c9ee141c2b33 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -17,9 +17,11 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
+#include <media/media-device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 
@@ -50,6 +52,19 @@ module_param(debug, bool, 0644);
  * offsets but for different queues */
 #define DST_QUEUE_OFF_BASE	(1 << 30)
 
+enum v4l2_m2m_entity_type {
+	MEM2MEM_ENT_TYPE_SOURCE,
+	MEM2MEM_ENT_TYPE_SINK,
+	MEM2MEM_ENT_TYPE_PROC,
+	MEM2MEM_ENT_TYPE_MAX
+};
+
+static const char * const m2m_entity_name[] = {
+	"source",
+	"sink",
+	"proc"
+};
+
 
 /**
  * struct v4l2_m2m_dev - per-device context
@@ -60,6 +75,15 @@ module_param(debug, bool, 0644);
  */
 struct v4l2_m2m_dev {
 	struct v4l2_m2m_ctx	*curr_ctx;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity	*source;
+	struct media_pad	source_pad;
+	struct media_entity	sink;
+	struct media_pad	sink_pad;
+	struct media_entity	proc;
+	struct media_pad	proc_pads[2];
+	struct media_intf_devnode *intf_devnode;
+#endif
 
 	struct list_head	job_queue;
 	spinlock_t		job_spinlock;
@@ -595,6 +619,158 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL(v4l2_m2m_mmap);
 
+void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)
+{
+	media_remove_intf_links(&m2m_dev->intf_devnode->intf);
+	media_devnode_remove(m2m_dev->intf_devnode);
+
+	media_entity_remove_links(m2m_dev->source);
+	media_entity_remove_links(&m2m_dev->sink);
+	media_entity_remove_links(&m2m_dev->proc);
+	media_device_unregister_entity(m2m_dev->source);
+	media_device_unregister_entity(&m2m_dev->sink);
+	media_device_unregister_entity(&m2m_dev->proc);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_unregister_media_controller);
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+static int v4l2_m2m_register_entity(struct media_device *mdev,
+	struct v4l2_m2m_dev *m2m_dev, enum v4l2_m2m_entity_type type,
+	int function)
+{
+	struct media_entity *entity;
+	struct media_pad *pads;
+	int num_pads;
+	int ret;
+
+	switch (type) {
+	case MEM2MEM_ENT_TYPE_SOURCE:
+		entity = m2m_dev->source;
+		pads = &m2m_dev->source_pad;
+		entity->name = m2m_entity_name[type];
+		pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		num_pads = 1;
+		break;
+	case MEM2MEM_ENT_TYPE_SINK:
+		entity = &m2m_dev->sink;
+		pads = &m2m_dev->sink_pad;
+		pads[0].flags = MEDIA_PAD_FL_SINK;
+		num_pads = 1;
+		break;
+	case MEM2MEM_ENT_TYPE_PROC:
+		entity = &m2m_dev->proc;
+		pads = m2m_dev->proc_pads;
+		pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		pads[1].flags = MEDIA_PAD_FL_SINK;
+		num_pads = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	entity->obj_type = MEDIA_ENTITY_TYPE_BASE;
+	entity->name = m2m_entity_name[type];
+	entity->function = function;
+
+	ret = media_entity_pads_init(entity, num_pads, pads);
+	if (ret)
+		return ret;
+	ret = media_device_register_entity(mdev, entity);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+#endif
+
+int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
+		struct video_device *vdev, int function)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev = vdev->v4l2_dev->mdev;
+	struct media_link *link;
+	int ret;
+
+	if (!mdev)
+		return 0;
+
+	/* A memory-to-memory device consists in two
+	 * DMA engine and one video processing entities.
+	 * The DMA engine entities are linked to a V4L interface
+	 */
+
+	/* Create the three entities with their pads */
+	m2m_dev->source = &vdev->entity;
+	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
+			MEM2MEM_ENT_TYPE_SOURCE, MEDIA_ENT_F_IO_V4L);
+	if (ret)
+		return ret;
+	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
+			MEM2MEM_ENT_TYPE_PROC, function);
+	if (ret)
+		goto err_rel_entity0;
+	ret = v4l2_m2m_register_entity(mdev, m2m_dev,
+			MEM2MEM_ENT_TYPE_SINK, MEDIA_ENT_F_IO_V4L);
+	if (ret)
+		goto err_rel_entity1;
+
+	/* Connect the three entities */
+	ret = media_create_pad_link(&m2m_dev->sink, 0, &m2m_dev->proc, 1,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		goto err_rel_entity2;
+
+	ret = media_create_pad_link(&m2m_dev->proc, 0, m2m_dev->source, 0,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		goto err_rm_links0;
+
+	/* Create video interface */
+	m2m_dev->intf_devnode = media_devnode_create(mdev,
+			MEDIA_INTF_T_V4L_VIDEO, 0,
+			VIDEO_MAJOR, vdev->minor);
+	if (!m2m_dev->intf_devnode) {
+		ret = -ENOMEM;
+		goto err_rm_links1;
+	}
+
+	/* Connect the two DMA engines to the interface */
+	link = media_create_intf_link(m2m_dev->source,
+			&m2m_dev->intf_devnode->intf, MEDIA_LNK_FL_ENABLED);
+	if (!link) {
+		ret = -ENOMEM;
+		goto err_rm_devnode;
+	}
+
+	link = media_create_intf_link(&m2m_dev->sink,
+			&m2m_dev->intf_devnode->intf, MEDIA_LNK_FL_ENABLED);
+	if (!link) {
+		ret = -ENOMEM;
+		goto err_rm_intf_link;
+	}
+	return 0;
+
+err_rm_intf_link:
+	media_remove_intf_links(&m2m_dev->intf_devnode->intf);
+err_rm_devnode:
+	media_devnode_remove(m2m_dev->intf_devnode);
+err_rm_links1:
+	media_entity_remove_links(&m2m_dev->sink);
+err_rm_links0:
+	media_entity_remove_links(&m2m_dev->proc);
+	media_entity_remove_links(m2m_dev->source);
+err_rel_entity2:
+	media_device_unregister_entity(&m2m_dev->proc);
+err_rel_entity1:
+	media_device_unregister_entity(&m2m_dev->sink);
+err_rel_entity0:
+	media_device_unregister_entity(m2m_dev->source);
+	return ret;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_register_media_controller);
+
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 {
 	struct v4l2_m2m_dev *m2m_dev;
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3a8262..36e252d2149a 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -53,6 +53,7 @@ struct v4l2_m2m_ops {
 	void (*unlock)(void *priv);
 };
 
+struct video_device;
 struct v4l2_m2m_dev;
 
 /**
@@ -328,6 +329,10 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
  */
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
 
+void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev);
+int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
+			struct video_device *vdev, int function);
+
 /**
  * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
  *
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c7e9a5cba24e..5f58c7ac04c0 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -132,6 +132,9 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
 #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
 #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
+#define MEDIA_ENT_F_PROC_VIDEO_DECODER		(MEDIA_ENT_F_BASE + 0x4007)
+#define MEDIA_ENT_F_PROC_VIDEO_ENCODER		(MEDIA_ENT_F_BASE + 0x4008)
+#define MEDIA_ENT_F_PROC_VIDEO_DEINTERLACER	(MEDIA_ENT_F_BASE + 0x4009)
 
 /*
  * Switch and bridge entity functions
-- 
2.17.1
