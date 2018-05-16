Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42959 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbeEPMRJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 08:17:09 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 3/4] media: rcar-vin: Handle digital subdev in link_notify
Date: Wed, 16 May 2018 14:16:55 +0200
Message-Id: <1526473016-30559-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle digital subdevices in link_notify callback. If the notified link
involves a digital subdevice, do not change routing of the VIN-CSI-2
devices.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 30 +++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 1003c8c..ea74c55 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -168,10 +168,36 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
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
+		for (i = 0; i < RCAR_VIN_NUM; i++) {
+			if (group->vin[i] && group->vin[i]->digital &&
+			    group->vin[i]->digital->subdev == sd) {
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
-- 
2.7.4
