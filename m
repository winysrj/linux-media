Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49578 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754536AbcKBN3q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:46 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 23/32] media: rcar-vin: parse Gen3 OF and setup media graph
Date: Wed,  2 Nov 2016 14:23:20 +0100
Message-Id: <20161102132329.436-24-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-core.c | 485 ++++++++++++++++++++++++++++
 1 file changed, 485 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 68a16c8..20fe377 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -350,6 +350,483 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 }
 
 /* -----------------------------------------------------------------------------
+ * CSI async notifier
+ */
+
+/* group lock should be held when calling this function */
+static void rvin_group_update_pads(struct rvin_graph_entity *entity)
+{
+	struct media_entity *ent = &entity->subdev->entity;
+	unsigned int i;
+
+	/* Make sure source pad idx are sane */
+	if (entity->source_pad_idx >= ent->num_pads ||
+	    ent->pads[entity->source_pad_idx].flags != MEDIA_PAD_FL_SOURCE) {
+		entity->source_pad_idx =
+			rvin_pad_idx(entity->subdev, MEDIA_PAD_FL_SOURCE);
+	}
+
+	/* Try to find sink for source, fall back 0 which always is sink */
+	entity->sink_pad_idx = 0;
+	for (i = 0; i < ent->num_pads; ++i) {
+		struct media_pad *sink = &ent->pads[i];
+
+		if (!(sink->flags & MEDIA_PAD_FL_SINK))
+			continue;
+
+		if (sink->index == entity->source_pad_idx)
+			continue;
+
+		if (media_entity_has_route(ent, sink->index,
+					   entity->source_pad_idx))
+			entity->sink_pad_idx = sink->index;
+	}
+}
+
+/* group lock should be held when calling this function */
+static int rvin_group_add_link(struct rvin_dev *vin,
+			       struct media_entity *source,
+			       unsigned int source_pad_idx,
+			       struct media_entity *sink,
+			       unsigned int sink_idx,
+			       u32 flags)
+{
+	struct media_pad *source_pad, *sink_pad;
+	int ret = 0;
+
+	source_pad = &source->pads[source_pad_idx];
+	sink_pad = &sink->pads[sink_idx];
+
+	if (!media_entity_find_link(source_pad, sink_pad))
+		ret = media_create_pad_link(source, source_pad_idx,
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
+		idx = vin->group->source[i].source_pad_idx;
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
+			sink = &vin->group->vin[n]->vdev.entity;
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
+
+		if (!rvin_mbus_supported(&vin->group->source[i])) {
+			vin_err(vin, "Unsupported media bus format for %s\n",
+				vin->group->source[i].subdev->name);
+			mutex_unlock(&vin->group->lock);
+			return -EINVAL;
+		}
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
+static int rvin_group_parse_v4l2(struct rvin_dev *vin,
+				 struct device_node *ep,
+				 struct v4l2_mbus_config *mbus_cfg)
+{
+	struct v4l2_of_endpoint v4l2_ep;
+	int ret;
+
+	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
+	if (ret) {
+		vin_err(vin, "Could not parse v4l2 endpoint\n");
+		return -EINVAL;
+	}
+
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+		vin_err(vin, "Unsupported media bus type for %s\n",
+			of_node_full_name(ep));
+		return -EINVAL;
+	}
+
+	mbus_cfg->type = v4l2_ep.bus_type;
+	mbus_cfg->flags = v4l2_ep.bus.mipi_csi2.flags;
+
+	return 0;
+}
+
+static int rvin_group_vin_num_from_bridge(struct rvin_dev *vin,
+					  struct device_node *node,
+					  int test)
+{
+	struct device_node *remote;
+	struct of_endpoint endpoint;
+	int num;
+
+	remote = of_parse_phandle(node, "remote-endpoint", 0);
+	if (!remote)
+		return -EINVAL;
+
+	of_graph_parse_endpoint(remote, &endpoint);
+	of_node_put(remote);
+
+	num = endpoint.id;
+
+	if (test != -1 && num != test) {
+		vin_err(vin, "VIN numbering error at %s, was %d now %d\n",
+			of_node_full_name(node), test, num);
+		return -EINVAL;
+	}
+
+	return num;
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
+		      struct v4l2_mbus_config *mbus_cfg,
+		      unsigned int *remote_pad)
+{
+	struct device_node *source, *ep, *rp;
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
+	ret = rvin_group_parse_v4l2(vin, ep, mbus_cfg);
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
+	unsigned int i, remote_pad;
+	int vin_num = -1;
+
+	*bitmap = 0;
+
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+
+		/* Check if instance is connected to the bridge */
+		ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 1, i);
+		if (!ep) {
+			vin_dbg(vin, "Bridge: %d not connected\n", i);
+			continue;
+		}
+
+		vin_num = rvin_group_vin_num_from_bridge(vin, ep, vin_num);
+		if (vin_num < 0) {
+			of_node_put(ep);
+			return vin_num;
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
+		source = rvin_group_get_source(vin, bridge,
+					       &vin->group->source[i].mbus_cfg,
+					       &remote_pad);
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
+		vin->group->source[i].source_pad_idx = remote_pad;
+
+		*bitmap |= BIT(i);
+
+		vin_dbg(vin, "Handle bridge %s and source %s pad %d\n",
+			of_node_full_name(bridge), of_node_full_name(source),
+			remote_pad);
+	}
+
+	/* Insert ourself in the group */
+	vin_dbg(vin, "I'm VIN number %d", vin_num);
+	if (vin->group->vin[vin_num] != NULL) {
+		vin_err(vin, "VIN number %d already occupied\n", vin_num);
+		return -EINVAL;
+	}
+	vin->group->vin[vin_num] = vin;
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
+		vin_err(vin, "Group notifier registration failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
  * Platform Device Driver
  */
 
@@ -422,6 +899,14 @@ static int rvin_graph_init(struct rvin_dev *vin)
 		vin->group = rvin_group_allocate(vin);
 		if (IS_ERR(vin->group))
 			return PTR_ERR(vin->group);
+
+		ret = rvin_group_graph_init(vin);
+		if (ret)
+			return ret;
+
+		ret = rvin_group_update_links(vin);
+		if (ret)
+			return ret;
 	}
 
 	return ret;
-- 
2.10.2

