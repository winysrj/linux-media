Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37396 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdCNTGs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:48 -0400
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
Subject: [PATCH v3 21/27] rcar-vin: add group allocator functions
Date: Tue, 14 Mar 2017 20:03:02 +0100
Message-Id: <20170314190308.25790-22-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In media controller mode all VIN instances needs to be part of the same
media graph. There is also a need to each VIN instance to know and in
some cases be able to communicate with other VIN instances.

Add a allocator framework where the first VIN instance to be probed
creates a shared data structure and creates a media device.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 112 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  40 ++++++++++
 2 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f560d27449b84882..c10770d5ec37816c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -20,12 +20,110 @@
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-of.h>
 
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
+			kref_put(&group->refcount, rvin_group_release);
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
  * Async notifier
  */
 
@@ -263,9 +361,13 @@ static int rvin_group_init(struct rvin_dev *vin)
 {
 	int ret;
 
+	vin->group = rvin_group_allocate(vin);
+	if (IS_ERR(vin->group))
+		return PTR_ERR(vin->group);
+
 	ret = rvin_v4l2_mc_probe(vin);
 	if (ret)
-		return ret;
+		goto error_group;
 
 	vin->pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_pads_init(&vin->vdev->entity, 1, &vin->pad);
@@ -275,6 +377,8 @@ static int rvin_group_init(struct rvin_dev *vin)
 	return 0;
 error_v4l2:
 	rvin_v4l2_mc_remove(vin);
+error_group:
+	rvin_group_delete(vin);
 
 	return ret;
 }
@@ -398,10 +502,12 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&vin->notifier);
 
-	if (vin->info->use_mc)
+	if (vin->info->use_mc) {
 		rvin_v4l2_mc_remove(vin);
-	else
+		rvin_group_delete(vin);
+	} else {
 		rvin_v4l2_remove(vin);
+	}
 
 	rvin_dma_remove(vin);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 06934313950253f4..94258bf7cd58d097 100644
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
  * struct rvin_info- Information about the particular VIN implementation
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
 	struct rvin_graph_entity digital;
 
+	struct rvin_group *group;
 	struct media_pad pad;
 
 	struct mutex lock;
@@ -162,6 +180,28 @@ struct rvin_dev {
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
2.12.0
