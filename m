Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44896 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbdLHBJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:04 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 21/28] rcar-vin: add group allocator functions
Date: Fri,  8 Dec 2017 02:08:35 +0100
Message-Id: <20171208010842.20047-22-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In media controller mode all VIN instances needs to be part of the same
media graph. There is also a need to each VIN instance to know and in
some cases be able to communicate with other VIN instances.

Add an allocator framework where the first VIN instance to be probed
creates a shared data structure and creates a media device.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 179 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  38 ++++++
 2 files changed, 215 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 45de4079fd835759..a6713fd61dd87a88 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -20,12 +20,170 @@
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
 
 #include "rcar-vin.h"
 
+/* -----------------------------------------------------------------------------
+ * Gen3 CSI2 Group Allocator
+ */
+
+static int rvin_group_read_id(struct rvin_dev *vin, struct device_node *np)
+{
+	u32 val;
+	int ret;
+
+	ret = of_property_read_u32(np, "renesas,id", &val);
+	if (ret) {
+		vin_err(vin, "%pOF: No renesas,id property found\n", np);
+		return -EINVAL;
+	}
+
+	if (val >= RCAR_VIN_NUM) {
+		vin_err(vin, "%pOF: Invalid renesas,id '%u'\n", np, val);
+		return -EINVAL;
+	}
+
+	return val;
+}
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
+static int rvin_group_add_vin(struct rvin_dev *vin)
+{
+	int ret;
+
+	ret = rvin_group_read_id(vin, vin->dev->of_node);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&vin->group->lock);
+
+	if (vin->group->vin[ret]) {
+		mutex_unlock(&vin->group->lock);
+		vin_err(vin, "VIN number %d already occupied\n", ret);
+		return -EINVAL;
+	}
+
+	vin->group->vin[ret] = vin;
+
+	mutex_unlock(&vin->group->lock);
+
+	vin_dbg(vin, "I'm VIN number %d", ret);
+
+	return 0;
+}
+
+static int rvin_group_allocate(struct rvin_dev *vin)
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
+		return -ENOMEM;
+	}
+
+	/* Init group data if it is not already initialized */
+	mdev = &group->mdev;
+	if (!mdev->dev) {
+		mutex_init(&group->lock);
+		mdev->dev = vin->dev;
+
+		strlcpy(mdev->driver_name, "Renesas VIN",
+			sizeof(mdev->driver_name));
+		strlcpy(mdev->model, vin->dev->of_node->name,
+			sizeof(mdev->model));
+
+		snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
+			 dev_name(mdev->dev));
+		media_device_init(mdev);
+
+		ret = media_device_register(mdev);
+		if (ret) {
+			vin_err(vin, "Failed to register media device\n");
+			kref_put(&group->refcount, rvin_group_release);
+			mutex_unlock(&rvin_group_lock);
+			return ret;
+		}
+	}
+
+	vin->group = group;
+	vin->v4l2_dev.mdev = mdev;
+
+	ret = rvin_group_add_vin(vin);
+	if (ret) {
+		kref_put(&group->refcount, rvin_group_release);
+		mutex_unlock(&rvin_group_lock);
+		return ret;
+	}
+
+	mutex_unlock(&rvin_group_lock);
+
+	return 0;
+}
+
+static void rvin_group_delete(struct rvin_dev *vin)
+{
+	unsigned int i;
+
+	mutex_lock(&vin->group->lock);
+	for (i = 0; i < RCAR_VIN_NUM; i++)
+		if (vin->group->vin[i] == vin)
+			vin->group->vin[i] = NULL;
+	mutex_unlock(&vin->group->lock);
+
+	vin_dbg(vin, "%s: group=%p\n", __func__, &vin->group);
+	kref_put(&vin->group->refcount, rvin_group_release);
+}
+
 /* -----------------------------------------------------------------------------
  * Async notifier
  */
@@ -236,12 +394,27 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 static int rvin_group_init(struct rvin_dev *vin)
 {
+	int ret;
+
+	ret = rvin_group_allocate(vin);
+	if (ret)
+		return ret;
+
 	/* All our sources are CSI-2 */
 	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
 	vin->mbus_cfg.flags = 0;
 
 	vin->pad.flags = MEDIA_PAD_FL_SINK;
-	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
+	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
+	if (ret)
+		goto error_group;
+
+	return 0;
+
+error_group:
+	rvin_group_delete(vin);
+
+	return ret;
 }
 
 /* -----------------------------------------------------------------------------
@@ -361,7 +534,9 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
-	if (!vin->info->use_mc)
+	if (vin->info->use_mc)
+		rvin_group_delete(vin);
+	else
 		v4l2_ctrl_handler_free(&vin->ctrl_handler);
 
 	rvin_dma_unregister(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 07d270a976893cdb..5f736a3500b6e10f 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -17,6 +17,8 @@
 #ifndef __RCAR_VIN__
 #define __RCAR_VIN__
 
+#include <linux/kref.h>
+
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
@@ -30,6 +32,9 @@
 /* Address alignment mask for HW buffers */
 #define HW_BUFFER_MASK 0x7f
 
+/* Max number on VIN instances that can be in a system */
+#define RCAR_VIN_NUM 8
+
 enum chip_id {
 	RCAR_H1,
 	RCAR_M1,
@@ -37,6 +42,15 @@ enum chip_id {
 	RCAR_GEN3,
 };
 
+enum rvin_csi_id {
+	RVIN_CSI20,
+	RVIN_CSI21,
+	RVIN_CSI40,
+	RVIN_CSI41,
+	RVIN_CSI_MAX,
+	RVIN_NC, /* Not Connected */
+};
+
 /**
  * STOPPED  - No operation in progress
  * RUNNING  - Operation in progress have buffers
@@ -75,6 +89,8 @@ struct rvin_graph_entity {
 	unsigned int sink_pad;
 };
 
+struct rvin_group;
+
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @chip:		type of VIN chip
@@ -103,6 +119,7 @@ struct rvin_info {
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
  *
+ * @group:		Gen3 CSI group
  * @pad:		pad for media controller
  *
  * @lock:		protects @queue
@@ -134,6 +151,7 @@ struct rvin_dev {
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity *digital;
 
+	struct rvin_group *group;
 	struct media_pad pad;
 
 	struct mutex lock;
@@ -162,6 +180,26 @@ struct rvin_dev {
 #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
 #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
 
+/**
+ * struct rvin_group - VIN CSI2 group information
+ * @refcount:		number of VIN instances using the group
+ *
+ * @mdev:		media device which represents the group
+ *
+ * @lock:		protects the vin and csi members
+ * @vin:		VIN instances which are part of the group
+ * @csi:		CSI-2 entities that are part of the group
+ */
+struct rvin_group {
+	struct kref refcount;
+
+	struct media_device mdev;
+
+	struct mutex lock;
+	struct rvin_dev *vin[RCAR_VIN_NUM];
+	struct rvin_graph_entity csi[RVIN_CSI_MAX];
+};
+
 int rvin_dma_register(struct rvin_dev *vin, int irq);
 void rvin_dma_unregister(struct rvin_dev *vin);
 
-- 
2.15.0
