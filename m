Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:4313 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164161AbeCBB7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:22 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 24/32] rcar-vin: add group allocator functions
Date: Fri,  2 Mar 2018 02:57:43 +0100
Message-Id: <20180302015751.25596-25-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In media controller mode all VIN instances needs to be part of the same
media graph. There is also a need for each VIN instance to know about
and in some cases be able to communicate with other VIN instances.

Add an allocator framework where the first VIN instance to be probed
creates a shared data structure and registers a media device.
Consecutive VINs insert themself into the global group.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 174 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  31 +++++
 2 files changed, 203 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index eb67ad5e2633064b..01132b9966509c1f 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -20,12 +20,174 @@
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
+/* FIXME:  This should if we find a system that supports more
+ * than one group for the whole system be replaced with a linked
+ * list of groups. And eventually all of this should be replaced
+ * with a global device allocator API.
+ *
+ * But for now this works as on all supported systems there will
+ * be only one group for all instances.
+ */
+
+static DEFINE_MUTEX(rvin_group_lock);
+static struct rvin_group *rvin_group_data;
+
+static void rvin_group_cleanup(struct rvin_group *group)
+{
+	media_device_unregister(&group->mdev);
+	media_device_cleanup(&group->mdev);
+	mutex_destroy(&group->lock);
+}
+
+static int rvin_group_init(struct rvin_group *group, struct rvin_dev *vin)
+{
+	struct media_device *mdev = &group->mdev;
+	const struct of_device_id *match;
+	struct device_node *np;
+	int ret;
+
+	mutex_init(&group->lock);
+
+	/* Count number of VINs in the system */
+	group->count = 0;
+	for_each_matching_node(np, vin->dev->driver->of_match_table)
+		if (of_device_is_available(np))
+			group->count++;
+
+	vin_dbg(vin, "found %u enabled VIN's in DT", group->count);
+
+	mdev->dev = vin->dev;
+
+	match = of_match_node(vin->dev->driver->of_match_table,
+			      vin->dev->of_node);
+
+	strlcpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
+	strlcpy(mdev->model, match->compatible, sizeof(mdev->model));
+	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
+		 dev_name(mdev->dev));
+
+	media_device_init(mdev);
+
+	ret = media_device_register(&group->mdev);
+	if (ret)
+		rvin_group_cleanup(group);
+
+	return ret;
+}
+
+static void rvin_group_release(struct kref *kref)
+{
+	struct rvin_group *group =
+		container_of(kref, struct rvin_group, refcount);
+
+	mutex_lock(&rvin_group_lock);
+
+	rvin_group_data = NULL;
+
+	rvin_group_cleanup(group);
+
+	kfree(group);
+
+	mutex_unlock(&rvin_group_lock);
+}
+
+static int rvin_group_get(struct rvin_dev *vin)
+{
+	struct rvin_group *group;
+	u32 id;
+	int ret;
+
+	/* Make sure VIN id is present and sane */
+	ret = of_property_read_u32(vin->dev->of_node, "renesas,id", &id);
+	if (ret) {
+		vin_err(vin, "%pOF: No renesas,id property found\n",
+			vin->dev->of_node);
+		return -EINVAL;
+	}
+
+	if (id >= RCAR_VIN_NUM) {
+		vin_err(vin, "%pOF: Invalid renesas,id '%u'\n",
+			vin->dev->of_node, id);
+		return -EINVAL;
+	}
+
+	/* Join or create a VIN group */
+	mutex_lock(&rvin_group_lock);
+	if (rvin_group_data) {
+		group = rvin_group_data;
+		kref_get(&group->refcount);
+	} else {
+		group = kzalloc(sizeof(*group), GFP_KERNEL);
+		if (!group) {
+			ret = -ENOMEM;
+			goto err_group;
+		}
+
+		ret = rvin_group_init(group, vin);
+		if (ret) {
+			kfree(group);
+			vin_err(vin, "Failed to initialize group\n");
+			goto err_group;
+		}
+
+		kref_init(&group->refcount);
+
+		rvin_group_data = group;
+	}
+	mutex_unlock(&rvin_group_lock);
+
+	/* Add VIN to group */
+	mutex_lock(&group->lock);
+
+	if (group->vin[id]) {
+		vin_err(vin, "Duplicate renesas,id property value %u\n", id);
+		mutex_unlock(&group->lock);
+		kref_put(&group->refcount, rvin_group_release);
+		return -EINVAL;
+	}
+
+	group->vin[id] = vin;
+
+	vin->id = id;
+	vin->group = group;
+	vin->v4l2_dev.mdev = &group->mdev;
+
+	mutex_unlock(&group->lock);
+
+	return 0;
+err_group:
+	mutex_unlock(&rvin_group_lock);
+	return ret;
+}
+
+static void rvin_group_put(struct rvin_dev *vin)
+{
+	mutex_lock(&vin->group->lock);
+
+	vin->group = NULL;
+	vin->v4l2_dev.mdev = NULL;
+
+	if (WARN_ON(vin->group->vin[vin->id] != vin))
+		goto out;
+
+	vin->group->vin[vin->id] = NULL;
+out:
+	mutex_unlock(&vin->group->lock);
+
+	kref_put(&vin->group->refcount, rvin_group_release);
+}
+
 /* -----------------------------------------------------------------------------
  * Async notifier
  */
@@ -243,12 +405,18 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 static int rvin_mc_init(struct rvin_dev *vin)
 {
+	int ret;
+
 	/* All our sources are CSI-2 */
 	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
 	vin->mbus_cfg.flags = 0;
 
 	vin->pad.flags = MEDIA_PAD_FL_SINK;
-	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
+	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
+	if (ret)
+		return ret;
+
+	return rvin_group_get(vin);
 }
 
 /* -----------------------------------------------------------------------------
@@ -368,7 +536,9 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
-	if (!vin->info->use_mc)
+	if (vin->info->use_mc)
+		rvin_group_put(vin);
+	else
 		v4l2_ctrl_handler_free(&vin->ctrl_handler);
 
 	rvin_dma_unregister(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 849f428871af113f..07cde9e1ab01ca51 100644
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
@@ -29,6 +31,11 @@
 /* Address alignment mask for HW buffers */
 #define HW_BUFFER_MASK 0x7f
 
+/* Max number on VIN instances that can be in a system */
+#define RCAR_VIN_NUM 8
+
+struct rvin_group;
+
 enum model_id {
 	RCAR_H1,
 	RCAR_M1,
@@ -101,6 +108,8 @@ struct rvin_info {
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
  *
+ * @group:		Gen3 CSI group
+ * @id:			Gen3 group id for this VIN
  * @pad:		media pad for the video device entity
  *
  * @lock:		protects @queue
@@ -132,6 +141,8 @@ struct rvin_dev {
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity *digital;
 
+	struct rvin_group *group;
+	unsigned int id;
 	struct media_pad pad;
 
 	struct mutex lock;
@@ -160,6 +171,26 @@ struct rvin_dev {
 #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
 #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
 
+/**
+ * struct rvin_group - VIN CSI2 group information
+ * @refcount:		number of VIN instances using the group
+ *
+ * @mdev:		media device which represents the group
+ *
+ * @lock:		protects the count and vin members
+ * @count:		number of enabled VIN instances found in DT
+ * @vin:		VIN instances which are part of the group
+ */
+struct rvin_group {
+	struct kref refcount;
+
+	struct media_device mdev;
+
+	struct mutex lock;
+	unsigned int count;
+	struct rvin_dev *vin[RCAR_VIN_NUM];
+};
+
 int rvin_dma_register(struct rvin_dev *vin, int irq);
 void rvin_dma_unregister(struct rvin_dev *vin);
 
-- 
2.16.2
