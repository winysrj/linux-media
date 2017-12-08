Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44870 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbdLHBJG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:06 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 23/28] rcar-vin: parse Gen3 OF and setup media graph
Date: Fri,  8 Dec 2017 02:08:37 +0100
Message-Id: <20171208010842.20047-24-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse the VIN Gen3 OF graph and register all CSI-2 devices in the VIN
group common media device. Once all CSI-2 subdevices are added to the
common media device create links between them.

The parsing and registering CSI-2 subdevices with the v4l2 async
framework is a collaborative effort shared between the VIN instances
which are part of the group. The first rcar-vin instance parses OF and
finds all other VIN and CSI-2 nodes which are part of the graph. It
stores a bit mask of all VIN instances found and handles to all CSI-2
nodes.

The bit mask is used to figure out when all VIN instances have been
probed. Once the last VIN instance is probed this is detected and this
instance registers all CSI-2 subdevices in its private async notifier.
Once the .complete() callback of this notifier is called it registers
all video devices and creates the media controller links between all
entities.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 320 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  10 +-
 2 files changed, 326 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index a6713fd61dd87a88..4a147437fa69c364 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -86,6 +86,7 @@ static struct rvin_group *__rvin_group_allocate(struct rvin_dev *vin)
 		return NULL;
 
 	kref_init(&group->refcount);
+	group->notifier = NULL;
 	rvin_group_data = group;
 
 	vin_dbg(vin, "%s: alloc group=%p\n", __func__, group);
@@ -392,10 +393,281 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
  * Group async notifier
  */
 
-static int rvin_group_init(struct rvin_dev *vin)
+/* group lock should be held when calling this function */
+static int rvin_group_add_link(struct rvin_dev *vin,
+			       struct media_entity *source,
+			       unsigned int source_idx,
+			       struct media_entity *sink,
+			       unsigned int sink_idx,
+			       u32 flags)
+{
+	struct media_pad *source_pad, *sink_pad;
+	int ret = 0;
+
+	source_pad = &source->pads[source_idx];
+	sink_pad = &sink->pads[sink_idx];
+
+	if (!media_entity_find_link(source_pad, sink_pad))
+		ret = media_create_pad_link(source, source_idx,
+					    sink, sink_idx, flags);
+
+	if (ret)
+		vin_err(vin, "Error adding link from %s to %s\n",
+			source->name, sink->name);
+
+	return ret;
+}
+
+static int rvin_group_update_links(struct rvin_dev *vin)
+{
+	struct media_entity *source, *sink;
+	struct rvin_dev *master;
+	unsigned int i, n, idx, csi;
+	int ret = 0;
+
+	mutex_lock(&vin->group->lock);
+
+	for (n = 0; n < RCAR_VIN_NUM; n++) {
+
+		/* Check that VIN is part of the group */
+		if (!vin->group->vin[n])
+			continue;
+
+		/* Check that subgroup master is part of the group */
+		master = vin->group->vin[n < 4 ? 0 : 4];
+		if (!master)
+			continue;
+
+		for (i = 0; i < vin->info->num_chsels; i++) {
+			csi = vin->info->chsels[n][i].csi;
+
+			/* If the CSI-2 is out of bounds it's a noop, skip */
+			if (csi >= RVIN_CSI_MAX)
+				continue;
+
+			/* Check that CSI-2 are part of the group */
+			if (!vin->group->csi[csi].subdev)
+				continue;
+
+			source = &vin->group->csi[csi].subdev->entity;
+			sink = &vin->group->vin[n]->vdev.entity;
+			idx = vin->info->chsels[n][i].chan + 1;
+
+			ret = rvin_group_add_link(vin, source, idx, sink, 0,
+						  0);
+			if (ret)
+				goto out;
+		}
+	}
+out:
+	mutex_unlock(&vin->group->lock);
+
+	return ret;
+}
+
+static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 {
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+	unsigned int i;
 	int ret;
 
+	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
+	if (ret) {
+		vin_err(vin, "Failed to register subdev nodes\n");
+		return ret;
+	}
+
+	for (i = 0; i < RCAR_VIN_NUM; i++) {
+		if (vin->group->vin[i]) {
+			ret = rvin_v4l2_register(vin->group->vin[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return rvin_group_update_links(vin);
+}
+
+static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
+{
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_graph_entity *csi = to_rvin_graph_entity(asd);
+	unsigned int i;
+
+	for (i = 0; i < RCAR_VIN_NUM; i++)
+		if (vin->group->vin[i])
+			rvin_v4l2_unregister(vin->group->vin[i]);
+
+	mutex_lock(&vin->group->lock);
+	csi->subdev = NULL;
+	mutex_unlock(&vin->group->lock);
+}
+
+static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_graph_entity *csi = to_rvin_graph_entity(asd);
+
+	v4l2_set_subdev_hostdata(subdev, vin);
+
+	mutex_lock(&vin->group->lock);
+	vin_dbg(vin, "Bound CSI-2 %s\n", subdev->name);
+	csi->subdev = subdev;
+	mutex_unlock(&vin->group->lock);
+
+	return 0;
+}
+
+static const struct v4l2_async_notifier_operations rvin_group_notify_ops = {
+	.bound = rvin_group_notify_bound,
+	.unbind = rvin_group_notify_unbind,
+	.complete = rvin_group_notify_complete,
+};
+
+static struct device_node *rvin_group_get_remote(struct rvin_dev *vin,
+						 struct device_node *node)
+{
+	struct device_node *np;
+
+	np = of_graph_get_remote_port_parent(node);
+	if (!np) {
+		vin_err(vin, "Remote port not found %pOF\n", node);
+		return NULL;
+	}
+
+	/* Not all remote ports are available, this is OK */
+	if (!of_device_is_available(np)) {
+		vin_dbg(vin, "Remote port %pOF is not available\n", np);
+		of_node_put(np);
+		return NULL;
+	}
+
+	return np;
+}
+
+/* group lock should be held when calling this function */
+static int rvin_group_graph_parse(struct rvin_dev *vin, struct device_node *np)
+{
+	int i, id, ret;
+
+	/* Read VIN id from DT */
+	id = rvin_group_read_id(vin, np);
+	if (id < 0)
+		return id;
+
+	/* Check if VIN is already handled */
+	if (vin->group->mask & BIT(id))
+		return 0;
+
+	vin->group->mask |= BIT(id);
+
+	vin_dbg(vin, "Handling VIN%d\n", id);
+
+	/* Parse all endpoints for CSI-2 and VIN nodes */
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		struct device_node *ep, *csi, *remote;
+
+		/* Check if instance is connected to the CSI-2 */
+		ep = of_graph_get_endpoint_by_regs(np, 1, i);
+		if (!ep) {
+			vin_dbg(vin, "VIN%d: ep %d not connected\n", id, i);
+			continue;
+		}
+
+		if (vin->group->csi[i].asd.match.fwnode.fwnode) {
+			of_node_put(ep);
+			vin_dbg(vin, "VIN%d: ep %d already handled\n", id, i);
+			continue;
+		}
+
+		csi = rvin_group_get_remote(vin, ep);
+		of_node_put(ep);
+		if (!csi)
+			continue;
+
+		vin->group->csi[i].asd.match.fwnode.fwnode =
+			of_fwnode_handle(csi);
+		vin->group->csi[i].asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+
+		vin_dbg(vin, "VIN%d ep: %d handled CSI-2 %pOF\n", id, i, csi);
+
+		/* Parse the CSI-2 for all VIN nodes connected to it */
+		ep = NULL;
+		while (1) {
+			ep = of_graph_get_next_endpoint(csi, ep);
+			if (!ep)
+				break;
+
+			remote = rvin_group_get_remote(vin, ep);
+			if (!remote)
+				continue;
+
+			if (of_match_node(vin->dev->driver->of_match_table,
+					  remote)) {
+				ret = rvin_group_graph_parse(vin, remote);
+				if (ret)
+					return ret;
+
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int rvin_group_graph_register(struct rvin_dev *vin)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	int i, n, ret, count = 0;
+
+	mutex_lock(&vin->group->lock);
+
+	/* Count how many CSI-2 nodes found */
+	for (i = 0; i < RVIN_CSI_MAX; i++)
+		if (vin->group->csi[i].asd.match.fwnode.fwnode)
+			count++;
+
+	if (!count) {
+		mutex_unlock(&vin->group->lock);
+		return 0;
+	}
+
+	/* Allocate and setup list of subdevices for the notifier */
+	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs) * count, GFP_KERNEL);
+	if (subdevs == NULL) {
+		mutex_unlock(&vin->group->lock);
+		return -ENOMEM;
+	}
+
+	n = 0;
+	for (i = 0; i < RVIN_CSI_MAX; i++)
+		if (vin->group->csi[i].asd.match.fwnode.fwnode)
+			subdevs[n++] = &vin->group->csi[i].asd;
+
+	vin_dbg(vin, "Claimed %d subdevices for group\n", count);
+
+	vin->notifier.num_subdevs = count;
+	vin->notifier.subdevs = subdevs;
+	vin->notifier.ops = &rvin_group_notify_ops;
+
+	mutex_unlock(&vin->group->lock);
+
+	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
+	if (ret < 0)
+		vin_err(vin, "Notifier registration failed\n");
+
+	return ret;
+}
+
+static int rvin_group_init(struct rvin_dev *vin)
+{
+	int i, ret, count_mask, count_vin = 0;
+	bool reg_notifier = false;
+
 	ret = rvin_group_allocate(vin);
 	if (ret)
 		return ret;
@@ -409,8 +681,45 @@ static int rvin_group_init(struct rvin_dev *vin)
 	if (ret)
 		goto error_group;
 
+	/*
+	 * Check number of registered VINs in group against the group mask.
+	 * If the mask is empty DT has not yet been parsed and if the
+	 * count matches all VINs are registered and it's safe to register
+	 * the async notifier
+	 */
+	mutex_lock(&vin->group->lock);
+
+	if (!vin->group->mask) {
+		ret = rvin_group_graph_parse(vin, vin->dev->of_node);
+		if (ret) {
+			mutex_unlock(&vin->group->lock);
+			goto error_group;
+		}
+	}
+
+	for (i = 0; i < RCAR_VIN_NUM; i++)
+		if (vin->group->vin[i])
+			count_vin++;
+
+	count_mask = hweight_long(vin->group->mask);
+
+	if (count_vin == count_mask && !vin->group->notifier) {
+		vin->group->notifier = &vin->notifier;
+		reg_notifier = true;
+	}
+
+	mutex_unlock(&vin->group->lock);
+
+	if (reg_notifier) {
+		ret = rvin_group_graph_register(vin);
+		if (ret)
+			goto error_vdev;
+	}
+
 	return 0;
 
+error_vdev:
+	rvin_v4l2_unregister(vin);
 error_group:
 	rvin_group_delete(vin);
 
@@ -534,10 +843,15 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
-	if (vin->info->use_mc)
+	if (vin->info->use_mc) {
+		mutex_lock(&vin->group->lock);
+		if (vin->group->notifier == &vin->notifier)
+			vin->group->notifier = NULL;
+		mutex_unlock(&vin->group->lock);
 		rvin_group_delete(vin);
-	else
+	} else {
 		v4l2_ctrl_handler_free(&vin->ctrl_handler);
+	}
 
 	rvin_dma_unregister(vin);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 41bf24aa8a1a0aed..2081ec6d3e7ac64f 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -92,6 +92,9 @@ struct rvin_graph_entity {
 	unsigned int sink_pad;
 };
 
+#define to_rvin_graph_entity(asd) \
+	container_of(asd, struct rvin_graph_entity, asd)
+
 struct rvin_group;
 
 /** struct rvin_group_chsel - Map a CSI-2 receiver and channel to a CHSEL value
@@ -211,7 +214,10 @@ struct rvin_dev {
  *
  * @mdev:		media device which represents the group
  *
- * @lock:		protects the vin and csi members
+ * @lock:		protects the mask, vin and csi members
+ * @mask:		Mask of VIN instances found in DT
+ * @notifier:		Pointer to the notifer of a VIN which handles the
+ *			groups async sub-devices.
  * @vin:		VIN instances which are part of the group
  * @csi:		CSI-2 entities that are part of the group
  */
@@ -221,6 +227,8 @@ struct rvin_group {
 	struct media_device mdev;
 
 	struct mutex lock;
+	unsigned long mask;
+	struct v4l2_async_notifier *notifier;
 	struct rvin_dev *vin[RCAR_VIN_NUM];
 	struct rvin_graph_entity csi[RVIN_CSI_MAX];
 };
-- 
2.15.0
