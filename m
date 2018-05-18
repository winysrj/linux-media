Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33611 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbeEROmE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:42:04 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 7/9] media: rcar-vin: Handle parallel subdev in link_notify
Date: Fri, 18 May 2018 16:40:43 +0200
Message-Id: <1526654445-10702-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle parallel subdevices in link_notify callback. If the notified link
involves a parallel subdevice, do not change routing of the VIN-CSI-2
devices and mark the VIN instance as using a parallel input. If the
CSI-2 link setup succeeds instead, mark the VIN instance as using CSI-2.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 36 +++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index d13bbcf..dcebb42 100644
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
+		 * a parallel input of one of the enabled VINs if it is not
+		 * one of the CSI-2 subdevices.
+		 *
+		 * No hardware configuration required for parallel inputs,
+		 * we can return here.
+		 */
+		sd = media_entity_to_v4l2_subdev(link->source->entity);
+		for (i = 0; i < RCAR_VIN_NUM; i++) {
+			if (group->vin[i] && group->vin[i]->parallel &&
+			    group->vin[i]->parallel->subdev == sd) {
+				group->vin[i]->is_csi = false;
+				ret = 0;
+				goto out;
+			}
+		}
+
+		vin_err(vin, "Subdevice %s not registered to any VIN\n",
+			link->source->entity->name);
+		ret = -ENODEV;
+		goto out;
+	}
 
+	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
 	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
 
 	if (!mask_new) {
@@ -181,6 +208,11 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 
 	/* New valid CHSEL found, set the new value. */
 	ret = rvin_set_channel_routing(group->vin[master_id], __ffs(mask_new));
+	if (ret)
+		goto out;
+
+	vin->is_csi = true;
+
 out:
 	mutex_unlock(&group->lock);
 
-- 
2.7.4
