Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38344 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752665AbeFLKtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:49:35 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [RFC 1/2] media: add helpers for memory-to-memory media controller
Date: Tue, 12 Jun 2018 07:48:26 -0300
Message-Id: <20180612104827.11565-2-ezequiel@collabora.com>
In-Reply-To: <20180612104827.11565-1-ezequiel@collabora.com>
References: <20180612104827.11565-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A memory-to-memory pipeline device consists in three
entities: two DMA engine and one video processing entities.
The DMA engine entities are linked to a V4L interface.

This commit add a new v4l2_m2m_{un}register_media_controller
API to register this topology.

For instance, a typical mem2mem device topology would
look like this:

- entity 1: input (1 pad, 1 link)
            type Node subtype Unknown flags 0
	pad0: Source
		-> "proc":1 [ENABLED,IMMUTABLE]

- entity 3: proc (2 pads, 2 links)
            type Node subtype Unknown flags 0
	pad0: Source
		-> "output":0 [ENABLED,IMMUTABLE]
	pad1: Sink
		<- "input":0 [ENABLED,IMMUTABLE]

- entity 6: output (1 pad, 1 link)
            type Node subtype Unknown flags 0
	pad0: Sink
		<- "proc":0 [ENABLED,IMMUTABLE]

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-dev.c     |  23 ++--
 drivers/media/v4l2-core/v4l2-mem2mem.c | 157 +++++++++++++++++++++++++
 include/media/media-entity.h           |   4 +
 include/media/v4l2-dev.h               |   2 +
 include/media/v4l2-mem2mem.h           |   5 +
 include/uapi/linux/media.h             |   2 +
 6 files changed, 186 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 4ffd7d60a901..ec8f20f0fdc5 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -202,7 +202,7 @@ static void v4l2_device_release(struct device *cd)
 	mutex_unlock(&videodev_lock);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev->mdev) {
+	if (v4l2_dev->mdev && vdev->vfl_type != VFL_TYPE_MEM2MEM) {
 		/* Remove interfaces and interface links */
 		media_devnode_remove(vdev->intf_devnode);
 		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
@@ -530,6 +530,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
 	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
 	bool is_tch = vdev->vfl_type == VFL_TYPE_TOUCH;
+	bool is_m2m = vdev->vfl_type == VFL_TYPE_MEM2MEM;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
@@ -576,7 +577,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 
-	if (is_vid || is_tch) {
+	if (is_vid || is_m2m || is_tch) {
 		/* video and metadata specific ioctls */
 		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
 			       ops->vidioc_enum_fmt_vid_cap_mplane ||
@@ -669,7 +670,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 	}
 
-	if (is_vid || is_vbi || is_sdr || is_tch) {
+	if (is_vid || is_m2m || is_vbi || is_sdr || is_tch) {
 		/* ioctls valid for video, metadata, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
@@ -682,7 +683,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	}
 
-	if (is_vid || is_vbi || is_tch) {
+	if (is_vid || is_m2m || is_vbi || is_tch) {
 		/* ioctls valid for video or vbi */
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
@@ -733,7 +734,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			BASE_VIDIOC_PRIVATE);
 }
 
-static int video_register_media_controller(struct video_device *vdev, int type)
+static int video_register_media_controller(struct video_device *vdev)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	u32 intf_type;
@@ -745,7 +746,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 	vdev->entity.obj_type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
 	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
 
-	switch (type) {
+	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
 		intf_type = MEDIA_INTF_T_V4L_VIDEO;
 		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
@@ -774,6 +775,10 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 		intf_type = MEDIA_INTF_T_V4L_SUBDEV;
 		/* Entity will be created via v4l2_device_register_subdev() */
 		break;
+	case VFL_TYPE_MEM2MEM:
+		/* Memory-to-memory devices are more complex and use
+		 * their own function to register.
+		 */
 	default:
 		return 0;
 	}
@@ -869,6 +874,10 @@ int __video_register_device(struct video_device *vdev,
 	case VFL_TYPE_TOUCH:
 		name_base = "v4l-touch";
 		break;
+	case VFL_TYPE_MEM2MEM:
+		/* Maintain this name for backwards compatibility */
+		name_base = "video";
+		break;
 	default:
 		pr_err("%s called with unknown type: %d\n",
 		       __func__, type);
@@ -993,7 +1002,7 @@ int __video_register_device(struct video_device *vdev,
 	v4l2_device_get(vdev->v4l2_dev);
 
 	/* Part 5: Register the entity. */
-	ret = video_register_media_controller(vdev, type);
+	ret = video_register_media_controller(vdev);
 
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index c4f963d96a79..0505b65bfa68 100644
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
 
@@ -50,6 +52,11 @@ module_param(debug, bool, 0644);
  * offsets but for different queues */
 #define DST_QUEUE_OFF_BASE	(1 << 30)
 
+struct v4l2_m2m_entity {
+	struct media_entity entity;
+	struct media_pad pads[2];
+	char name[64];
+};
 
 /**
  * struct v4l2_m2m_dev - per-device context
@@ -60,6 +67,10 @@ module_param(debug, bool, 0644);
  */
 struct v4l2_m2m_dev {
 	struct v4l2_m2m_ctx	*curr_ctx;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct v4l2_m2m_entity	entities[3];
+	struct media_intf_devnode *intf_devnode;
+#endif
 
 	struct list_head	job_queue;
 	spinlock_t		job_spinlock;
@@ -595,6 +606,152 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL(v4l2_m2m_mmap);
 
+void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)
+{
+	int i;
+
+	media_remove_intf_links(&m2m_dev->intf_devnode->intf);
+	media_devnode_remove(m2m_dev->intf_devnode);
+
+	for (i = 0; i < 3; i++)
+		media_entity_remove_links(&m2m_dev->entities[i].entity);
+	for (i = 0; i < 3; i++)
+		media_device_unregister_entity(&m2m_dev->entities[i].entity);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_unregister_media_controller);
+
+#define MEM2MEM_ENT_TYPE_INPUT	1
+#define MEM2MEM_ENT_TYPE_OUTPUT	2
+#define MEM2MEM_ENT_TYPE_PROC	3
+
+static int v4l2_m2m_register_entity(struct media_device *mdev,
+		struct v4l2_m2m_entity *m2m_entity, int type)
+{
+	unsigned int function;
+	int num_pads;
+	int ret;
+
+	switch (type) {
+	case MEM2MEM_ENT_TYPE_INPUT:
+		function = MEDIA_ENT_F_IO_DMAENGINE;
+		m2m_entity->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		strlcpy(m2m_entity->name, "input", sizeof(m2m_entity->name));
+		num_pads = 1;
+		break;
+	case MEM2MEM_ENT_TYPE_OUTPUT:
+		function = MEDIA_ENT_F_IO_DMAENGINE;
+		m2m_entity->pads[0].flags = MEDIA_PAD_FL_SINK;
+		strlcpy(m2m_entity->name, "output", sizeof(m2m_entity->name));
+		num_pads = 1;
+		break;
+	case MEM2MEM_ENT_TYPE_PROC:
+		function = MEDIA_ENT_F_PROC_VIDEO_TRANSFORM;
+		m2m_entity->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		m2m_entity->pads[1].flags = MEDIA_PAD_FL_SINK;
+		strlcpy(m2m_entity->name, "proc", sizeof(m2m_entity->name));
+		num_pads = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = media_entity_pads_init(&m2m_entity->entity, num_pads, m2m_entity->pads);
+	if (ret)
+		return ret;
+
+	m2m_entity->entity.obj_type = MEDIA_ENTITY_TYPE_MEM2MEM;
+	m2m_entity->entity.function = function;
+	m2m_entity->entity.name = m2m_entity->name;
+	ret = media_device_register_entity(mdev, &m2m_entity->entity);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev, struct video_device *vdev)
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
+	ret = v4l2_m2m_register_entity(mdev, &m2m_dev->entities[0], MEM2MEM_ENT_TYPE_INPUT);
+	if (ret)
+		return ret;
+	ret = v4l2_m2m_register_entity(mdev, &m2m_dev->entities[1], MEM2MEM_ENT_TYPE_PROC);
+	if (ret)
+		goto err_rel_entity0;
+	ret = v4l2_m2m_register_entity(mdev, &m2m_dev->entities[2], MEM2MEM_ENT_TYPE_OUTPUT);
+	if (ret)
+		goto err_rel_entity1;
+
+	/* Connect the three entities */
+        ret = media_create_pad_link(&m2m_dev->entities[0].entity, 0,
+			&m2m_dev->entities[1].entity, 1,
+                        MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		goto err_rel_entity2;
+
+        ret = media_create_pad_link(&m2m_dev->entities[1].entity, 0,
+			&m2m_dev->entities[2].entity, 0,
+                        MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		goto err_rm_links0;
+
+	/* Create video interface */
+	m2m_dev->intf_devnode = media_devnode_create(mdev, MEDIA_INTF_T_V4L_VIDEO, 0, VIDEO_MAJOR, vdev->minor);
+	if (!m2m_dev->intf_devnode) {
+		ret = -ENOMEM;
+		goto err_rm_links1;
+	}
+
+	/* Connect the two DMA engines to the interface */
+	link = media_create_intf_link(&m2m_dev->entities[0].entity, &m2m_dev->intf_devnode->intf,
+				MEDIA_LNK_FL_ENABLED);
+	if (!link) {
+		ret = -ENOMEM;
+		goto err_rm_devnode;
+	}
+
+	link = media_create_intf_link(&m2m_dev->entities[1].entity, &m2m_dev->intf_devnode->intf,
+				MEDIA_LNK_FL_ENABLED);
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
+	media_entity_remove_links(&m2m_dev->entities[2].entity);
+err_rm_links0:
+	media_entity_remove_links(&m2m_dev->entities[1].entity);
+	media_entity_remove_links(&m2m_dev->entities[0].entity);
+err_rel_entity2:
+	media_device_unregister_entity(&m2m_dev->entities[2].entity);
+err_rel_entity1:
+	media_device_unregister_entity(&m2m_dev->entities[1].entity);
+err_rel_entity0:
+	media_device_unregister_entity(&m2m_dev->entities[0].entity);
+	return ret;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_register_media_controller);
+
 struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 {
 	struct v4l2_m2m_dev *m2m_dev;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3aa3d58d1d58..ff6fbe8333e1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -206,6 +206,9 @@ struct media_entity_operations {
  *	The entity is embedded in a struct video_device instance.
  * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
  *	The entity is embedded in a struct v4l2_subdev instance.
+ * @MEDIA_ENTITY_TYPE_V4L2_MEM2MEM:
+ *	The entity is not embedded in any struct, but part of
+ *	a memory-to-memory topology.
  *
  * Media entity objects are often not instantiated directly, but the media
  * entity structure is inherited by (through embedding) other subsystem-specific
@@ -222,6 +225,7 @@ enum media_entity_type {
 	MEDIA_ENTITY_TYPE_BASE,
 	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
 	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
+	MEDIA_ENTITY_TYPE_MEM2MEM,
 };
 
 /**
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 456ac13eca1d..a9df949bb9c3 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -30,6 +30,7 @@
  * @VFL_TYPE_SUBDEV:	for V4L2 subdevices
  * @VFL_TYPE_SDR:	for Software Defined Radio tuners
  * @VFL_TYPE_TOUCH:	for touch sensors
+ * @VFL_TYPE_MEM2MEM:	for mem2mem devices
  * @VFL_TYPE_MAX:	number of VFL types, must always be last in the enum
  */
 enum vfl_devnode_type {
@@ -39,6 +40,7 @@ enum vfl_devnode_type {
 	VFL_TYPE_SUBDEV,
 	VFL_TYPE_SDR,
 	VFL_TYPE_TOUCH,
+	VFL_TYPE_MEM2MEM,
 	VFL_TYPE_MAX /* Shall be the last one */
 };
 
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3a8262..9dfe9bd23f89 100644
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
 
+int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev, struct video_device *vdev);
+
+void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev);
+
 /**
  * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
  *
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c7e9a5cba24e..becb7db77f6a 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -81,6 +81,7 @@ struct media_device_info {
 #define MEDIA_ENT_F_IO_DTV			(MEDIA_ENT_F_BASE + 0x01001)
 #define MEDIA_ENT_F_IO_VBI			(MEDIA_ENT_F_BASE + 0x01002)
 #define MEDIA_ENT_F_IO_SWRADIO			(MEDIA_ENT_F_BASE + 0x01003)
+#define MEDIA_ENT_F_IO_DMAENGINE		(MEDIA_ENT_F_BASE + 0x01004)
 
 /*
  * Sensor functions
@@ -132,6 +133,7 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
 #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
 #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
+#define MEDIA_ENT_F_PROC_VIDEO_TRANSFORM	(MEDIA_ENT_F_BASE + 0x4007)
 
 /*
  * Switch and bridge entity functions
-- 
2.17.1
