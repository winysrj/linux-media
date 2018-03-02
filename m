Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:49283 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164158AbeCBB72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:28 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 28/32] rcar-vin: add link notify for Gen3
Date: Fri,  2 Mar 2018 02:57:47 +0100
Message-Id: <20180302015751.25596-29-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the ability to process media device link change request. Link
enabling is a bit complicated on Gen3, whether or not it's possible to
enable a link depends on what other links already are enabled. On Gen3
the 8 VINs are split into two subgroup's (VIN0-3 and VIN4-7) and from a
routing perspective these two groups are independent of each other.
Each subgroup's routing is controlled by the subgroup VIN master
instance (VIN0 and VIN4).

There are a limited number of possible route setups available for each
subgroup and the configuration of each setup is dictated by the
hardware. On H3 for example there are 6 possible route setups for each
subgroup to choose from.

This leads to the media device link notification code being rather large
since it will find the best routing configuration to try and accommodate
as many links as possible. When it's not possible to enable a new link
due to hardware constrains the link_notifier callback will return
-EMLINK.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 153 ++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 3ddd7d8fecd52909..c015f3c284439285 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -24,6 +24,7 @@
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
+#include <media/v4l2-mc.h>
 
 #include "rcar-vin.h"
 
@@ -44,6 +45,157 @@
  */
 #define rvin_group_id_to_master(vin) ((vin) < 4 ? 0 : 4)
 
+/* -----------------------------------------------------------------------------
+ * Media Controller link notification
+ */
+
+/* group lock should be held when calling this function. */
+static int rvin_group_entity_to_csi_id(struct rvin_group *group,
+				       struct media_entity *entity)
+{
+	struct v4l2_subdev *sd;
+	unsigned int i;
+
+	sd = media_entity_to_v4l2_subdev(entity);
+
+	for (i = 0; i < RVIN_CSI_MAX; i++)
+		if (group->csi[i].subdev == sd)
+			return i;
+
+	return -ENODEV;
+}
+
+static unsigned int rvin_group_get_mask(struct rvin_dev *vin,
+					enum rvin_csi_id csi_id,
+					unsigned char chan)
+{
+	const struct rvin_group_route *route;
+	unsigned int mask = 0;
+
+	for (route = vin->info->routes; route->mask; route++) {
+		if (route->vin == vin->id &&
+		    route->csi == csi_id &&
+		    route->chan == chan) {
+			vin_dbg(vin, "Adding route: vin: %d csi: %d chan: %d\n",
+				route->vin, route->csi, route->chan);
+			mask |= route->mask;
+		}
+	}
+
+	return mask;
+}
+
+/*
+ * Link setup for the links between a VIN and a CSI-2 receiver is a bit
+ * complex. The reason for this is that the register controlling routing
+ * are not present in each VIN instance. There are special VINs which
+ * control routing for itself and other VINs. There are not many
+ * different possible links combinations that can be enabled at the same
+ * time, therefor all already enabled links which are controlled by a
+ * master VIN needs to be taken into account when making the decision
+ * if a new link can be enabled or not.
+ *
+ * 1. Find out which VIN the link the user tries to enable is connected to.
+ * 2. Lookup which master VIN controls the links for this VIN.
+ * 3. Start with a bitmask with all bits set.
+ * 4. For each previously enabled link from the master VIN bitwise AND its
+ *    route mask (see documentation for mask in struct rvin_group_route)
+ *    with the bitmask.
+ * 5. Bitwise AND the mask for the link the user tries to enable to the bitmask.
+ * 6. If the bitmask is not empty at this point the new link can be enabled
+ *    while keeping all previous links enabled. Update the CHSEL value of the
+ *    master VIN and inform the user that the link could be enabled.
+ *
+ * Please note that no link can be enabled if any VIN in the group is
+ * currently streaming.
+ */
+static int rvin_group_link_notify(struct media_link *link, u32 flags,
+				  unsigned int notification)
+{
+	struct rvin_group *group = container_of(link->graph_obj.mdev,
+						struct rvin_group, mdev);
+	unsigned int master_id, chan, mask_new, i;
+	unsigned int mask = ~0;
+	struct media_entity *entity;
+	struct video_device *vdev;
+	struct media_pad *csi_pad;
+	struct rvin_dev *vin = NULL;
+	int csi_id, ret;
+
+	ret = v4l2_pipeline_link_notify(link, flags, notification);
+	if (ret)
+		return ret;
+
+	/* Only care about link enablement for VIN nodes. */
+	if (!(flags & MEDIA_LNK_FL_ENABLED) ||
+	    !is_media_entity_v4l2_video_device(link->sink->entity))
+		return 0;
+
+	/* If any entity is in use don't allow link changes. */
+	media_device_for_each_entity(entity, &group->mdev)
+		if (entity->use_count)
+			return -EBUSY;
+
+	mutex_lock(&group->lock);
+
+	/*
+	 * Figure out which VIN the link concern's and lookup
+	 * which master VIN controls the routes for that VIN.
+	 */
+	vdev = media_entity_to_video_device(link->sink->entity);
+	for (i = 0; i < RCAR_VIN_NUM; i++) {
+		if (group->vin[i] && &group->vin[i]->vdev == vdev) {
+			vin = group->vin[i];
+			master_id = rvin_group_id_to_master(vin->id);
+			break;
+		}
+	}
+	if (WARN_ON(!vin || !group->vin[master_id])) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* Build a mask for already enabled links. */
+	for (i = master_id; i < master_id + 4; i++) {
+		if (!group->vin[i])
+			continue;
+
+		/* Get remote CSI-2, if any. */
+		csi_pad = media_entity_remote_pad(
+				&group->vin[i]->vdev.entity.pads[0]);
+		if (!csi_pad)
+			continue;
+
+		csi_id = rvin_group_entity_to_csi_id(group, csi_pad->entity);
+		chan = rvin_group_csi_pad_to_chan(csi_pad->index);
+
+		mask &= rvin_group_get_mask(group->vin[i], csi_id, chan);
+	}
+
+	/* Add the new link to the existing mask and check if it works. */
+	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
+	chan = rvin_group_csi_pad_to_chan(link->source->index);
+	mask_new = mask & rvin_group_get_mask(vin, csi_id, chan);
+
+	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
+
+	if (!mask_new) {
+		ret = -EMLINK;
+		goto out;
+	}
+
+	/* New valid CHSEL found, set the new value. */
+	ret = rvin_set_channel_routing(group->vin[master_id], __ffs(mask_new));
+out:
+	mutex_unlock(&group->lock);
+
+	return ret;
+}
+
+static const struct media_device_ops rvin_media_ops = {
+	.link_notify = rvin_group_link_notify,
+};
+
 /* -----------------------------------------------------------------------------
  * Gen3 CSI2 Group Allocator
  */
@@ -85,6 +237,7 @@ static int rvin_group_init(struct rvin_group *group, struct rvin_dev *vin)
 	vin_dbg(vin, "found %u enabled VIN's in DT", group->count);
 
 	mdev->dev = vin->dev;
+	mdev->ops = &rvin_media_ops;
 
 	match = of_match_node(vin->dev->driver->of_match_table,
 			      vin->dev->of_node);
-- 
2.16.2
