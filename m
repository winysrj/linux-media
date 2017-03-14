Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37445 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdCNTGu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:50 -0400
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
Subject: [PATCH v3 23/27] rcar-vin: parse Gen3 OF and setup media graph
Date: Tue, 14 Mar 2017 20:03:04 +0100
Message-Id: <20170314190308.25790-24-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse the VIN Gen3 OF graph and register all devices in the CSI2 group
common media device. Once a subdevice is added to the common media
device list as many links as possible are added and if possible enabled.

The links between the video source device and the CSI2 bridge are
enabled as immutable since they can't change during runtime. While the
link between the CSI2 bridge and the VIN video device are enabled
according the CHSEL routing table suitable for the SoC.

The parsing and registering subdevices is a collaborative effort shared
between all rcar-vin instances which are part of the CSI2 group. Which
ever rcar-vin instance which fist sees a new subdevice in the graph adds
it to its private v4l2 async notifier and once it's bound it will be
available for the whole CSI2 group.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 472 +++++++++++++++++++++++++++-
 1 file changed, 459 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index c10770d5ec37816c..d3a9bd007dea73d7 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -158,21 +158,32 @@ static int rvin_parse_v4l2(struct rvin_dev *vin,
 
 	mbus_cfg->type = v4l2_ep.bus_type;
 
-	switch (mbus_cfg->type) {
-	case V4L2_MBUS_PARALLEL:
-		vin_dbg(vin, "Found PARALLEL media bus\n");
-		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
-		break;
-	case V4L2_MBUS_BT656:
-		vin_dbg(vin, "Found BT656 media bus\n");
-		mbus_cfg->flags = 0;
-		break;
-	default:
-		vin_err(vin, "Unknown media bus type\n");
-		return -EINVAL;
+	if (vin->info->chip == RCAR_GEN3) {
+		switch (mbus_cfg->type) {
+		case V4L2_MBUS_CSI2:
+			vin_dbg(vin, "Found CSI-2 media bus\n");
+			mbus_cfg->flags = 0;
+			return 0;
+		default:
+			break;
+		}
+	} else {
+		switch (mbus_cfg->type) {
+		case V4L2_MBUS_PARALLEL:
+			vin_dbg(vin, "Found PARALLEL media bus\n");
+			mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
+			return 0;
+		case V4L2_MBUS_BT656:
+			vin_dbg(vin, "Found BT656 media bus\n");
+			mbus_cfg->flags = 0;
+			return 0;
+		default:
+			break;
+		}
 	}
 
-	return 0;
+	vin_err(vin, "Unknown media bus type\n");
+	return -EINVAL;
 }
 
 /* -----------------------------------------------------------------------------
@@ -357,6 +368,431 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
  * Group async notifier
  */
 
+/* group lock should be held when calling this function */
+static void rvin_group_update_pads(struct rvin_graph_entity *entity)
+{
+	struct media_entity *ent = &entity->subdev->entity;
+	unsigned int i;
+
+	/* Make sure source pad idx are sane */
+	if (entity->source_pad >= ent->num_pads ||
+	    ent->pads[entity->source_pad].flags != MEDIA_PAD_FL_SOURCE) {
+		entity->source_pad =
+			rvin_find_pad(entity->subdev, MEDIA_PAD_FL_SOURCE);
+	}
+
+	/* Try to find sink for source, fall back 0 which always is sink */
+	entity->sink_pad = 0;
+	for (i = 0; i < ent->num_pads; ++i) {
+		struct media_pad *sink = &ent->pads[i];
+
+		if (!(sink->flags & MEDIA_PAD_FL_SINK))
+			continue;
+
+		if (sink->index == entity->source_pad)
+			continue;
+
+		if (media_entity_has_route(ent, sink->index,
+					   entity->source_pad))
+			entity->sink_pad = sink->index;
+	}
+}
+
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
+	unsigned int i, n, idx, chsel, csi;
+	u32 flags;
+	int ret;
+
+	mutex_lock(&vin->group->lock);
+
+	/* Update Source -> Bridge */
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		if (!vin->group->source[i].subdev)
+			continue;
+
+		if (!vin->group->bridge[i].subdev)
+			continue;
+
+		source = &vin->group->source[i].subdev->entity;
+		sink = &vin->group->bridge[i].subdev->entity;
+		idx = vin->group->source[i].source_pad;
+		flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
+
+		ret = rvin_group_add_link(vin, source, idx, sink, 0, flags);
+		if (ret)
+			goto out;
+	}
+
+	/* Update Bridge -> VIN */
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
+		chsel = rvin_get_chsel(master);
+
+		for (i = 0; i < vin->info->num_chsels; i++) {
+			csi = vin->info->chsels[n][i].csi;
+
+			/* If the CSI is out of bounds it's a no operate skip */
+			if (csi >= RVIN_CSI_MAX)
+				continue;
+
+			/* Check that bridge are part of the group */
+			if (!vin->group->bridge[csi].subdev)
+				continue;
+
+			source = &vin->group->bridge[csi].subdev->entity;
+			sink = &vin->group->vin[n]->vdev->entity;
+			idx = vin->info->chsels[n][i].chan + 1;
+			flags = i == chsel ? MEDIA_LNK_FL_ENABLED : 0;
+
+			ret = rvin_group_add_link(vin, source, idx, sink, 0,
+						  flags);
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
+{
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+	unsigned int i;
+	int ret;
+
+	mutex_lock(&vin->group->lock);
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		if (!vin->group->source[i].subdev)
+			continue;
+
+		rvin_group_update_pads(&vin->group->source[i]);
+	}
+	mutex_unlock(&vin->group->lock);
+
+	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
+	if (ret) {
+		vin_err(vin, "Failed to register subdev nodes\n");
+		return ret;
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
+	unsigned int i;
+
+	mutex_lock(&vin->group->lock);
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		struct device_node *del = subdev->dev->of_node;
+
+		if (vin->group->bridge[i].asd.match.of.node == del) {
+			vin_dbg(vin, "Unbind bridge %s\n", subdev->name);
+			vin->group->bridge[i].subdev = NULL;
+			mutex_unlock(&vin->group->lock);
+			return;
+		}
+
+		if (vin->group->source[i].asd.match.of.node == del) {
+			vin_dbg(vin, "Unbind source %s\n", subdev->name);
+			vin->group->source[i].subdev = NULL;
+			mutex_unlock(&vin->group->lock);
+			return;
+		}
+	}
+	mutex_unlock(&vin->group->lock);
+
+	vin_err(vin, "No entity for subdev %s to unbind\n", subdev->name);
+}
+
+static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+	unsigned int i;
+
+	v4l2_set_subdev_hostdata(subdev, vin);
+
+	mutex_lock(&vin->group->lock);
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		struct device_node *new = subdev->dev->of_node;
+
+		if (vin->group->bridge[i].asd.match.of.node == new) {
+			vin_dbg(vin, "Bound bridge %s\n", subdev->name);
+			vin->group->bridge[i].subdev = subdev;
+			mutex_unlock(&vin->group->lock);
+			return 0;
+		}
+
+		if (vin->group->source[i].asd.match.of.node == new) {
+			vin_dbg(vin, "Bound source %s\n", subdev->name);
+			vin->group->source[i].subdev = subdev;
+			mutex_unlock(&vin->group->lock);
+			return 0;
+		}
+	}
+	mutex_unlock(&vin->group->lock);
+
+	vin_err(vin, "No entity for subdev %s to bind\n", subdev->name);
+	return -EINVAL;
+}
+
+static struct device_node *rvin_group_get_bridge(struct rvin_dev *vin,
+						 struct device_node *node)
+{
+	struct device_node *bridge;
+
+	bridge = of_graph_get_remote_port_parent(node);
+	if (!bridge) {
+		vin_err(vin, "No bridge found %s\n", of_node_full_name(node));
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Not all bridges are available, this is OK */
+	if (!of_device_is_available(bridge)) {
+		vin_dbg(vin, "Bridge %s not available\n",
+			of_node_full_name(bridge));
+		of_node_put(bridge);
+		return NULL;
+	}
+
+	return bridge;
+}
+
+static struct device_node *
+rvin_group_get_source(struct rvin_dev *vin,
+		      struct device_node *bridge,
+		      unsigned int *remote_pad)
+{
+	struct device_node *source, *ep, *rp;
+	struct v4l2_mbus_config mbus_cfg;
+	struct of_endpoint endpoint;
+	int ret;
+
+	ep = of_graph_get_endpoint_by_regs(bridge, 0, 0);
+	if (!ep) {
+		vin_dbg(vin, "Endpoint %s not connected to source\n",
+			of_node_full_name(ep));
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Check that source uses a supported media bus */
+	ret = rvin_parse_v4l2(vin, ep, &mbus_cfg);
+	if (ret) {
+		of_node_put(ep);
+		return ERR_PTR(ret);
+	}
+
+	rp = of_graph_get_remote_port(ep);
+	of_graph_parse_endpoint(rp, &endpoint);
+	of_node_put(rp);
+	*remote_pad = endpoint.id;
+
+	source = of_graph_get_remote_port_parent(ep);
+	of_node_put(ep);
+	if (!source) {
+		vin_err(vin, "No source found for endpoint '%s'\n",
+			of_node_full_name(ep));
+		return ERR_PTR(-EINVAL);
+	}
+
+	return source;
+}
+
+/* group lock should be held when calling this function */
+static int rvin_group_graph_parse(struct rvin_dev *vin, unsigned long *bitmap)
+{
+	struct device_node *ep, *bridge, *source;
+	unsigned int i, remote_pad = 0;
+	u32 val;
+	int ret;
+
+	*bitmap = 0;
+
+	/* Figure out which VIN we are */
+	ret = of_property_read_u32(vin->dev->of_node, "renesas,id", &val);
+	if (ret) {
+		vin_err(vin, "No renesas,id property found\n");
+		return ret;
+	}
+
+	if (val >= RCAR_VIN_NUM) {
+		vin_err(vin, "Invalid renesas,id '%u'\n", val);
+		return -EINVAL;
+	}
+
+	if (vin->group->vin[val] != NULL) {
+		vin_err(vin, "VIN number %d already occupied\n", val);
+		return -EINVAL;
+	}
+
+	vin_dbg(vin, "I'm VIN number %u", val);
+	vin->group->vin[val] = vin;
+
+	/* Parse all CSI-2 nodes */
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+
+		/* Check if instance is connected to the bridge */
+		ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 1, i);
+		if (!ep) {
+			vin_dbg(vin, "Bridge: %d not connected\n", i);
+			continue;
+		}
+
+		if (vin->group->bridge[i].asd.match.of.node) {
+			of_node_put(ep);
+			vin_dbg(vin, "Bridge: %d handled by other device\n", i);
+			continue;
+		}
+
+		bridge = rvin_group_get_bridge(vin, ep);
+		of_node_put(ep);
+		if (IS_ERR(bridge))
+			return PTR_ERR(bridge);
+		if (bridge == NULL)
+			continue;
+
+		source = rvin_group_get_source(vin, bridge, &remote_pad);
+		of_node_put(bridge);
+		if (IS_ERR(source))
+			return PTR_ERR(source);
+		if (source == NULL)
+			continue;
+
+		of_node_put(source);
+
+		vin->group->bridge[i].asd.match.of.node = bridge;
+		vin->group->bridge[i].asd.match_type = V4L2_ASYNC_MATCH_OF;
+		vin->group->source[i].asd.match.of.node = source;
+		vin->group->source[i].asd.match_type = V4L2_ASYNC_MATCH_OF;
+		vin->group->source[i].source_pad = remote_pad;
+
+		*bitmap |= BIT(i);
+
+		vin_dbg(vin, "Handle bridge %s and source %s pad %d\n",
+			of_node_full_name(bridge), of_node_full_name(source),
+			remote_pad);
+	}
+
+	/* All our sources are CSI-2 */
+	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
+	vin->mbus_cfg.flags = 0;
+
+	return 0;
+}
+
+/* group lock should be held when calling this function */
+static void rvin_group_graph_revert(struct rvin_dev *vin, unsigned long bitmap)
+{
+	int bit;
+
+	for_each_set_bit(bit, &bitmap, RVIN_CSI_MAX) {
+		vin_dbg(vin, "Reverting graph for %s\n",
+			of_node_full_name(vin->dev->of_node));
+		vin->group->bridge[bit].asd.match.of.node = NULL;
+		vin->group->bridge[bit].asd.match_type = 0;
+		vin->group->source[bit].asd.match.of.node = NULL;
+		vin->group->source[bit].asd.match_type = 0;
+	}
+}
+
+static int rvin_group_graph_init(struct rvin_dev *vin)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	unsigned long bitmap;
+	int i, bit, count, ret;
+
+	mutex_lock(&vin->group->lock);
+
+	ret = rvin_group_graph_parse(vin, &bitmap);
+	if (ret) {
+		rvin_group_graph_revert(vin, bitmap);
+		mutex_unlock(&vin->group->lock);
+		return ret;
+	}
+
+	/* Check if instance need to handle subdevices on behalf of the group */
+	count = hweight_long(bitmap) * 2;
+	if (!count) {
+		mutex_unlock(&vin->group->lock);
+		return 0;
+	}
+
+	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs) * count, GFP_KERNEL);
+	if (subdevs == NULL) {
+		rvin_group_graph_revert(vin, bitmap);
+		mutex_unlock(&vin->group->lock);
+		return -ENOMEM;
+	}
+
+	i = 0;
+	for_each_set_bit(bit, &bitmap, RVIN_CSI_MAX) {
+		subdevs[i++] = &vin->group->bridge[bit].asd;
+		subdevs[i++] = &vin->group->source[bit].asd;
+	}
+
+	vin_dbg(vin, "Claimed %d subdevices for group\n", count);
+
+	vin->notifier.num_subdevs = count;
+	vin->notifier.subdevs = subdevs;
+	vin->notifier.bound = rvin_group_notify_bound;
+	vin->notifier.unbind = rvin_group_notify_unbind;
+	vin->notifier.complete = rvin_group_notify_complete;
+
+	mutex_unlock(&vin->group->lock);
+
+	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
+	if (ret < 0) {
+		vin_err(vin, "Notifier registration failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int rvin_group_init(struct rvin_dev *vin)
 {
 	int ret;
@@ -374,7 +810,17 @@ static int rvin_group_init(struct rvin_dev *vin)
 	if (ret)
 		goto error_v4l2;
 
+	ret = rvin_group_graph_init(vin);
+	if (ret)
+		goto error_v4l2;
+
+	ret = rvin_group_update_links(vin);
+	if (ret)
+		goto error_async;
+
 	return 0;
+error_async:
+	v4l2_async_notifier_unregister(&vin->notifier);
 error_v4l2:
 	rvin_v4l2_mc_remove(vin);
 error_group:
-- 
2.12.0
