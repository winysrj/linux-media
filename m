Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:36603 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbeEKJ7x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 05:59:53 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/5] media: rcar-vin: [un]bind and link digital subdevice
Date: Fri, 11 May 2018 11:59:39 +0200
Message-Id: <1526032781-14319-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for binding and unbinding digital subdevices to rcar-vin.
On 'complete' also create direct links between the VIN instance and the
digital subdevice.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 133 +++++++++++++++++++++++-----
 1 file changed, 110 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 105b6b6..93c37b0 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -168,10 +168,37 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 	}
 
 	/* Add the new link to the existing mask and check if it works. */
-	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
 	channel = rvin_group_csi_pad_to_channel(link->source->index);
-	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
+	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
+	if (csi_id == -ENODEV) {
+		struct v4l2_subdev *sd;
+		unsigned int i;
+
+		/*
+		 * Make sure the source entity subdevice is registered as
+		 * a digital input of one of the enabled VINs if it is not
+		 * one of the CSI-2 subdevices.
+		 *
+		 * No hardware configuration required for digital inputs,
+		 * we can return here.
+		 */
+		sd = media_entity_to_v4l2_subdev(link->source->entity);
+
+		for (i = 0; i < RCAR_VIN_NUM; i++) {
+			if (group->vin[i] && group->vin[i]->digital &&
+			    group->vin[i]->digital->subdev == sd) {
+				ret = 0;
+				goto out;
+			}
+		}
 
+		vin_err(vin, "Subdevice %s not registered to any VIN\n",
+			link->source->entity->name);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
 	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
 
 	if (!mask_new) {
@@ -583,50 +610,70 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 {
-	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_dev *gvin = notifier_to_vin(notifier);
 	const struct rvin_group_route *route;
+	struct media_entity *source;
+	struct media_entity *sink;
 	unsigned int i;
 	int ret;
 
-	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
+	ret = v4l2_device_register_subdev_nodes(&gvin->v4l2_dev);
 	if (ret) {
-		vin_err(vin, "Failed to register subdev nodes\n");
+		vin_err(gvin, "Failed to register subdev nodes\n");
 		return ret;
 	}
 
-	/* Register all video nodes for the group. */
 	for (i = 0; i < RCAR_VIN_NUM; i++) {
-		if (vin->group->vin[i]) {
-			ret = rvin_v4l2_register(vin->group->vin[i]);
-			if (ret)
-				return ret;
+		struct rvin_dev *ivin;
+
+		if (!gvin->group->vin[i])
+			continue;
+
+		/* Register all video nodes for the group. */
+		ivin = gvin->group->vin[i];
+		ret = rvin_v4l2_register(ivin);
+		if (ret)
+			return ret;
+
+		/* Link the digital input, if any. */
+		if (!ivin->digital || !ivin->digital->subdev)
+			continue;
+
+		source = &ivin->digital->subdev->entity;
+		sink = &ivin->vdev.entity;
+
+		ret = media_create_pad_link(source, ivin->digital->source_pad,
+					    sink, ivin->digital->sink_pad, 0);
+		if (ret) {
+			vin_err(gvin, "Error adding link from %s to %s\n",
+				source->name, sink->name);
+			return ret;
 		}
 	}
 
 	/* Create all media device links between VINs and CSI-2's. */
-	mutex_lock(&vin->group->lock);
-	for (route = vin->info->routes; route->mask; route++) {
+	mutex_lock(&gvin->group->lock);
+	for (route = gvin->info->routes; route->mask; route++) {
 		struct media_pad *source_pad, *sink_pad;
-		struct media_entity *source, *sink;
 		unsigned int source_idx;
 
 		/* Check that VIN is part of the group. */
-		if (!vin->group->vin[route->vin])
+		if (!gvin->group->vin[route->vin])
 			continue;
 
 		/* Check that VIN' master is part of the group. */
-		if (!vin->group->vin[rvin_group_id_to_master(route->vin)])
+		if (!gvin->group->vin[rvin_group_id_to_master(route->vin)])
 			continue;
 
 		/* Check that CSI-2 is part of the group. */
-		if (!vin->group->csi[route->csi].subdev)
+		if (!gvin->group->csi[route->csi].subdev)
 			continue;
 
-		source = &vin->group->csi[route->csi].subdev->entity;
+		source = &gvin->group->csi[route->csi].subdev->entity;
 		source_idx = rvin_group_csi_channel_to_pad(route->channel);
 		source_pad = &source->pads[source_idx];
 
-		sink = &vin->group->vin[route->vin]->vdev.entity;
+		sink = &gvin->group->vin[route->vin]->vdev.entity;
 		sink_pad = &sink->pads[0];
 
 		/* Skip if link already exists. */
@@ -635,12 +682,12 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 
 		ret = media_create_pad_link(source, source_idx, sink, 0, 0);
 		if (ret) {
-			vin_err(vin, "Error adding link from %s to %s\n",
+			vin_err(gvin, "Error adding link from %s to %s\n",
 				source->name, sink->name);
 			break;
 		}
 	}
-	mutex_unlock(&vin->group->lock);
+	mutex_unlock(&gvin->group->lock);
 
 	return ret;
 }
@@ -650,6 +697,7 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_group *group = vin->group;
 	unsigned int i;
 
 	for (i = 0; i < RCAR_VIN_NUM; i++)
@@ -658,6 +706,23 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 
 	mutex_lock(&vin->group->lock);
 
+	/* Check if this is a digital subdevice first, then try with CSI-2. */
+	for (i = 0; i < RCAR_VIN_NUM; i++)
+		if (group->vin[i] && group->vin[i]->digital &&
+		    group->vin[i]->digital->asd.match.fwnode ==
+		    asd->match.fwnode)
+			break;
+
+	if (i < RCAR_VIN_NUM) {
+		group->vin[i]->digital->subdev = NULL;
+		vin_dbg(vin, "Unbind digital subdevice %s from VIN %u\n",
+			subdev->name, i);
+
+		mutex_unlock(&vin->group->lock);
+
+		return;
+	}
+
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
 		if (vin->group->csi[i].fwnode != asd->match.fwnode)
 			continue;
@@ -674,14 +739,36 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 				   struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_group *group = vin->group;
 	unsigned int i;
 
-	mutex_lock(&vin->group->lock);
+	mutex_lock(&group->lock);
+
+	/* Check if this is a digital subdevice first, then try with CSI-2. */
+	for (i = 0; i < RCAR_VIN_NUM; i++)
+		if (group->vin[i] && group->vin[i]->digital &&
+		    group->vin[i]->digital->asd.match.fwnode ==
+		    asd->match.fwnode)
+			break;
+
+	if (i < RCAR_VIN_NUM) {
+		group->vin[i]->digital->subdev = subdev;
+		group->vin[i]->digital->sink_pad = RVIN_PORT_DIGITAL;
+		group->vin[i]->digital->source_pad = rvin_find_pad(subdev,
+							   MEDIA_PAD_FL_SOURCE);
+
+		vin_dbg(vin, "Bound digital subdevice %s to VIN %u\n",
+			subdev->name, i);
+
+		mutex_unlock(&vin->group->lock);
+
+		return 0;
+	}
 
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
-		if (vin->group->csi[i].fwnode != asd->match.fwnode)
+		if (group->csi[i].fwnode != asd->match.fwnode)
 			continue;
-		vin->group->csi[i].subdev = subdev;
+		group->csi[i].subdev = subdev;
 		vin_dbg(vin, "Bound CSI-2 %s to slot %u\n", subdev->name, i);
 		break;
 	}
-- 
2.7.4
