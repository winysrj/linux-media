Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56114 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752868AbdHVX2t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:49 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 22/25] rcar-vin: add link notify for Gen3
Date: Wed, 23 Aug 2017 01:26:37 +0200
Message-Id: <20170822232640.26147-23-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the ability to process media device link change request. Link
enablement are a bit complicated on Gen3, if it's possible to enable a
link depends on what other links already are enabled. On Gen3 the 8 VIN
are split into two subgroups (VIN0-3 and VIN4-7) and from a routing
perspective these two groups are independent of each other. Each
subgroups routing is controlled by the subgroup VIN master instance
(VIN0 and VIN4).

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
 drivers/media/platform/rcar-vin/rcar-core.c | 203 ++++++++++++++++++++++++++++
 1 file changed, 203 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 2aba442a0750e91a..dec91e2f3ccdbd93 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -26,6 +26,207 @@
 
 #include "rcar-vin.h"
 
+/* -----------------------------------------------------------------------------
+ * Media Controller link notification
+ */
+
+static unsigned int rvin_group_csi_pad_to_chan(unsigned int pad)
+{
+	/*
+	 * The CSI2 driver is rcar-csi2 and we know it's pad layout are
+	 * 0: Source 1-4: Sinks so if we remove one from the pad we
+	 * get the rcar-vin internal CSI2 channel number
+	 */
+	return pad - 1;
+}
+
+/* group lock should be held when calling this function */
+static int rvin_group_entity_to_vin_num(struct rvin_group *group,
+					struct media_entity *entity)
+{
+	struct video_device *vdev;
+	int i;
+
+	if (!is_media_entity_v4l2_video_device(entity))
+		return -ENODEV;
+
+	vdev = media_entity_to_video_device(entity);
+
+	for (i = 0; i < RCAR_VIN_NUM; i++) {
+		if (!group->vin[i])
+			continue;
+
+		if (&group->vin[i]->vdev == vdev)
+			return i;
+	}
+
+	return -ENODEV;
+}
+
+/* group lock should be held when calling this function */
+static int rvin_group_entity_to_csi_num(struct rvin_group *group,
+					struct media_entity *entity)
+{
+	struct v4l2_subdev *sd;
+	int i;
+
+	if (!is_media_entity_v4l2_subdev(entity))
+		return -ENODEV;
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
+/* group lock should be held when calling this function */
+static void __rvin_group_build_link_list(struct rvin_group *group,
+					 struct rvin_group_chsel *map,
+					 int start, int len)
+{
+	struct media_pad *vin_pad, *remote_pad;
+	unsigned int n;
+
+	for (n = 0; n < len; n++) {
+		map[n].csi = -1;
+		map[n].chan = -1;
+
+		if (!group->vin[start + n])
+			continue;
+
+		vin_pad = &group->vin[start + n]->vdev.entity.pads[0];
+
+		remote_pad = media_entity_remote_pad(vin_pad);
+		if (!remote_pad)
+			continue;
+
+		map[n].csi =
+			rvin_group_entity_to_csi_num(group, remote_pad->entity);
+		map[n].chan = rvin_group_csi_pad_to_chan(remote_pad->index);
+	}
+}
+
+/* group lock should be held when calling this function */
+static int __rvin_group_try_get_chsel(struct rvin_group *group,
+				      struct rvin_group_chsel *map,
+				      int start, int len)
+{
+	const struct rvin_group_chsel *sel;
+	unsigned int i, n;
+	int chsel;
+
+	for (i = 0; i < group->vin[start]->info->num_chsels; i++) {
+		chsel = i;
+		for (n = 0; n < len; n++) {
+
+			/* If the link is not active it's OK */
+			if (map[n].csi == -1)
+				continue;
+
+			/* Check if chsel match requested link */
+			sel = &group->vin[start]->info->chsels[start + n][i];
+			if (map[n].csi != sel->csi ||
+			    map[n].chan != sel->chan) {
+				chsel = -1;
+				break;
+			}
+		}
+
+		/* A chsel which satisfy the links have been found */
+		if (chsel != -1)
+			return chsel;
+	}
+
+	/* No chsel can satisfy the requested links */
+	return -1;
+}
+
+/* group lock should be held when calling this function */
+static bool rvin_group_in_use(struct rvin_group *group)
+{
+	struct media_entity *entity;
+
+	media_device_for_each_entity(entity, &group->mdev)
+		if (entity->use_count)
+			return true;
+
+	return false;
+}
+
+static int rvin_group_link_notify(struct media_link *link, u32 flags,
+				  unsigned int notification)
+{
+	struct rvin_group *group = container_of(link->graph_obj.mdev,
+						struct rvin_group, mdev);
+	struct rvin_group_chsel chsel_map[4];
+	int vin_num, vin_master, csi_num, csi_chan;
+	unsigned int chsel;
+
+	mutex_lock(&group->lock);
+
+	vin_num = rvin_group_entity_to_vin_num(group, link->sink->entity);
+	csi_num = rvin_group_entity_to_csi_num(group, link->source->entity);
+	csi_chan = rvin_group_csi_pad_to_chan(link->source->index);
+
+	/*
+	 * Figure out which VIN node is the subgroup master.
+	 *
+	 * VIN0-3 are controlled by VIN0
+	 * VIN4-7 are controlled by VIN4
+	 */
+	vin_master = vin_num < 4 ? 0 : 4;
+
+	/* If not all devices exists something is horribly wrong */
+	if (vin_num < 0 || csi_num < 0 || !group->vin[vin_master])
+		goto error;
+
+	/* Special checking only needed for links which are to be enabled */
+	if (notification != MEDIA_DEV_NOTIFY_PRE_LINK_CH ||
+	    !(flags & MEDIA_LNK_FL_ENABLED))
+		goto out;
+
+	/* If any link in the group are in use, no new link can be enabled */
+	if (rvin_group_in_use(group))
+		goto error;
+
+	/* If the VIN already have a active link it's busy */
+	if (media_entity_remote_pad(&link->sink->entity->pads[0]))
+		goto error;
+
+	/* Build list of active links */
+	__rvin_group_build_link_list(group, chsel_map, vin_master, 4);
+
+	/* Add the new proposed link */
+	chsel_map[vin_num - vin_master].csi = csi_num;
+	chsel_map[vin_num - vin_master].chan = csi_chan;
+
+	/* See if there is a chsel value which match our link selection */
+	chsel = __rvin_group_try_get_chsel(group, chsel_map, vin_master, 4);
+
+	/* No chsel can provide the request links */
+	if (chsel == -1)
+		goto error;
+
+	/* Update chsel value at group master */
+	rvin_set_chsel(group->vin[vin_master], chsel);
+
+out:
+	mutex_unlock(&group->lock);
+
+	return v4l2_pipeline_link_notify(link, flags, notification);
+error:
+	mutex_unlock(&group->lock);
+
+	return -EMLINK;
+}
+
+static const struct media_device_ops rvin_media_ops = {
+	.link_notify = rvin_group_link_notify,
+};
+
 /* -----------------------------------------------------------------------------
  * Gen3 CSI2 Group Allocator
  */
@@ -146,6 +347,8 @@ static int rvin_group_allocate(struct rvin_dev *vin)
 			sizeof(mdev->bus_info));
 		media_device_init(mdev);
 
+		mdev->ops = &rvin_media_ops;
+
 		ret = media_device_register(mdev);
 		if (ret) {
 			vin_err(vin, "Failed to register media device\n");
-- 
2.14.0
