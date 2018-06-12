Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:48963 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbeFLJny (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 05:43:54 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v6 08/10] media: rcar-vin: Handle parallel subdev in link_notify
Date: Tue, 12 Jun 2018 11:43:30 +0200
Message-Id: <1528796612-7387-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle parallel subdevices in link_notify callback. If the notified link
involves a parallel subdevice, do not change routing of the VIN-CSI-2
devices and mark the VIN instance as using a parallel input. If the
CSI-2 link setup succeeds instead, mark the VIN instance as using CSI-2.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 35 ++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 98fe121..8950af1 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -171,9 +171,37 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 
 	/* Add the new link to the existing mask and check if it works. */
 	csi_id = rvin_group_entity_to_csi_id(group, link->source->entity);
+
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
+
 	channel = rvin_group_csi_pad_to_channel(link->source->index);
 	mask_new = mask & rvin_group_get_mask(vin, csi_id, channel);
-
 	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
 
 	if (!mask_new) {
@@ -183,6 +211,11 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 
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
