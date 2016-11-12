Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33569 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966031AbcKLNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:52 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 21/32] media: rcar-vin: add group allocator functions
Date: Sat, 12 Nov 2016 14:12:05 +0100
Message-Id: <20161112131216.22635-22-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 all VIN instances which wish to interact with with the shared
CSI2 resource needs to be part of the same media device and share other
information, such as subdevices and be able to call routing operations
on other VIN instances.

This patch adds a group allocator which joins all VIN instances in one
group. Inspiration for this patch is taken from Shuah Khans patch series
'Media Device Allocator API' which do a similar thing but allows a media
device to be shared across different drivers. The use case here is to
share group information between multiple instances of the same driver.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 103 ++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  |  41 +++++++++++
 2 files changed, 144 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6554141..c21f029 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -26,6 +26,102 @@
 #include "rcar-vin.h"
 
 /* -----------------------------------------------------------------------------
+ * Gen3 CSI2 Group Allocator
+ */
+
+static DEFINE_MUTEX(rvin_group_lock);
+static struct rvin_group *rvin_group_data;
+
+static void rvin_group_release(struct kref *kref)
+{
+	struct rvin_group *group =
+		container_of(kref, struct rvin_group, refcount);
+
+	mutex_lock(&rvin_group_lock);
+
+	media_device_unregister(&group->mdev);
+	media_device_cleanup(&group->mdev);
+
+	rvin_group_data = NULL;
+
+	mutex_unlock(&rvin_group_lock);
+
+	kfree(group);
+}
+
+static struct rvin_group *__rvin_group_allocate(struct rvin_dev *vin)
+{
+	struct rvin_group *group;
+
+	if (rvin_group_data) {
+		group = rvin_group_data;
+		kref_get(&group->refcount);
+		vin_dbg(vin, "%s: get group=%p\n", __func__, group);
+		return group;
+	}
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return NULL;
+
+	kref_init(&group->refcount);
+	rvin_group_data = group;
+
+	vin_dbg(vin, "%s: alloc group=%p\n", __func__, group);
+	return group;
+}
+
+static struct rvin_group *rvin_group_allocate(struct rvin_dev *vin)
+{
+	struct rvin_group *group;
+	struct media_device *mdev;
+	int ret;
+
+	mutex_lock(&rvin_group_lock);
+
+	group = __rvin_group_allocate(vin);
+	if (!group) {
+		mutex_unlock(&rvin_group_lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Init group data if its not already initialized */
+	mdev = &group->mdev;
+	if (!mdev->dev) {
+		mutex_init(&group->lock);
+		mdev->dev = vin->dev;
+
+		strlcpy(mdev->driver_name, "Renesas VIN",
+			sizeof(mdev->driver_name));
+		strlcpy(mdev->model, vin->dev->of_node->name,
+			sizeof(mdev->model));
+		strlcpy(mdev->bus_info, of_node_full_name(vin->dev->of_node),
+			sizeof(mdev->bus_info));
+		mdev->driver_version = LINUX_VERSION_CODE;
+		media_device_init(mdev);
+
+		ret = media_device_register(mdev);
+		if (ret) {
+			vin_err(vin, "Failed to register media device\n");
+			mutex_unlock(&rvin_group_lock);
+			return ERR_PTR(ret);
+		}
+	}
+
+	vin->v4l2_dev.mdev = mdev;
+
+	mutex_unlock(&rvin_group_lock);
+
+	return group;
+}
+
+static void rvin_group_delete(struct rvin_dev *vin)
+{
+	vin_dbg(vin, "%s: group=%p\n", __func__, &vin->group);
+	kref_put(&vin->group->refcount, rvin_group_release);
+}
+
+/* -----------------------------------------------------------------------------
  * Subdevice helpers
  */
 
@@ -322,6 +418,10 @@ static int rvin_graph_init(struct rvin_dev *vin)
 		ret = media_entity_pads_init(&vin->vdev.entity, 1, vin->pads);
 		if (ret)
 			return ret;
+
+		vin->group = rvin_group_allocate(vin);
+		if (IS_ERR(vin->group))
+			return PTR_ERR(vin->group);
 	}
 
 	return ret;
@@ -390,6 +490,9 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	rvin_v4l2_remove(vin);
 
+	if (vin->group)
+		rvin_group_delete(vin);
+
 	v4l2_async_notifier_unregister(&vin->notifier);
 
 	rvin_dma_remove(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 8ed43be..90c28a7 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -17,10 +17,13 @@
 #ifndef __RCAR_VIN__
 #define __RCAR_VIN__
 
+#include <linux/kref.h>
+
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-mc.h>
 #include <media/videobuf2-v4l2.h>
 
 /* Number of HW buffers */
@@ -29,6 +32,9 @@
 /* Address alignment mask for HW buffers */
 #define HW_BUFFER_MASK 0x7f
 
+/* Max number on VIN instances that can be in a system */
+#define RCAR_VIN_NUM 8
+
 enum chip_id {
 	RCAR_H1,
 	RCAR_M1,
@@ -36,6 +42,15 @@ enum chip_id {
 	RCAR_GEN3,
 };
 
+enum rvin_csi_id {
+	RVIN_CSI20,
+	RVIN_CSI21,
+	RVIN_CSI40,
+	RVIN_CSI41,
+	RVIN_CSI_MAX,
+	RVIN_NOOPE,
+};
+
 enum rvin_pads {
 	RVIN_SINK,
 	RVIN_PAD_MAX,
@@ -94,6 +109,8 @@ struct rvin_graph_entity {
 	int sink_pad_idx;
 };
 
+struct rvin_group;
+
 /**
  * struct rvin_info- Information about the particular VIN implementation
  * @chip:		type of VIN chip
@@ -120,6 +137,7 @@ struct rvin_info {
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
  *
+ * @group:		Gen3 CSI group
  * @pads:		pads for media controller
  *
  * @lock:		protects @queue
@@ -151,6 +169,7 @@ struct rvin_dev {
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity digital;
 
+	struct rvin_group *group;
 	struct media_pad pads[RVIN_PAD_MAX];
 
 	struct mutex lock;
@@ -180,6 +199,28 @@ struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin);
 #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
 #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
 
+/**
+ * struct rvin_group - VIN CSI2 group information
+ * @refcount:		number of VIN instances using the group
+ *
+ * @mdev:		media device which represents the group
+ *
+ * @lock:		protects the vin, bridge and source members
+ * @vin:		VIN instances which are part of the group
+ * @bridge:		CSI2 bridge between video source and VIN
+ * @source:		video source connected to each bridge
+ */
+struct rvin_group {
+	struct kref refcount;
+
+	struct media_device mdev;
+
+	struct mutex lock;
+	struct rvin_dev *vin[RCAR_VIN_NUM];
+	struct rvin_graph_entity bridge[RVIN_CSI_MAX];
+	struct rvin_graph_entity source[RVIN_CSI_MAX];
+};
+
 int rvin_dma_probe(struct rvin_dev *vin, int irq);
 void rvin_dma_remove(struct rvin_dev *vin);
 
-- 
2.10.2

