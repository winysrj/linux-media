Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45776C00319
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 22:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CE05222A4
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 22:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389933AbfBMWOk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 17:14:40 -0500
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:15396 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388994AbfBMWOk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 17:14:40 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2019 17:14:40 EST
X-Halon-ID: e39726f8-2fdb-11e9-a58a-005056917f90
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-02.atm.binero.net (Halon) with ESMTPA
        id e39726f8-2fdb-11e9-a58a-005056917f90;
        Wed, 13 Feb 2019 23:08:33 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: Fix lockdep warning at stream on
Date:   Wed, 13 Feb 2019 23:07:54 +0100
Message-Id: <20190213220754.14664-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes to v4l2-fwnode in commit [1] triggered a lockdep warning in
rcar-vin. The first attempt to solve this warning in the rcar-vin driver
was incomplete and only pushed the warning to happen at at stream on
time instead of at probe time.

This change reverts the incomplete fix and properly fix the warning by
removing the need to hold the rcar-vin specific group lock when calling
v4l2_async_notifier_parse_fwnode_endpoints_by_port(). And instead takes
it in the callback where it's really needed.

1. commit eae2aed1eab9bf08 ("media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev")

Fixes: 6458afc8c49148f0 ("media: rcar-vin: remove unneeded locking in async callbacks")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 43 +++++++++++++++------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 594d804340047511..abbb5820223965e3 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -546,7 +546,9 @@ static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
 
 	vin_dbg(vin, "unbind parallel subdev %s\n", subdev->name);
 
+	mutex_lock(&vin->lock);
 	rvin_parallel_subdevice_detach(vin);
+	mutex_unlock(&vin->lock);
 }
 
 static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
@@ -556,7 +558,9 @@ static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	int ret;
 
+	mutex_lock(&vin->lock);
 	ret = rvin_parallel_subdevice_attach(vin, subdev);
+	mutex_unlock(&vin->lock);
 	if (ret)
 		return ret;
 
@@ -664,6 +668,7 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 	}
 
 	/* Create all media device links between VINs and CSI-2's. */
+	mutex_lock(&vin->group->lock);
 	for (route = vin->info->routes; route->mask; route++) {
 		struct media_pad *source_pad, *sink_pad;
 		struct media_entity *source, *sink;
@@ -699,6 +704,7 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 			break;
 		}
 	}
+	mutex_unlock(&vin->group->lock);
 
 	return ret;
 }
@@ -714,6 +720,8 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 		if (vin->group->vin[i])
 			rvin_v4l2_unregister(vin->group->vin[i]);
 
+	mutex_lock(&vin->group->lock);
+
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
 		if (vin->group->csi[i].fwnode != asd->match.fwnode)
 			continue;
@@ -721,6 +729,8 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 		vin_dbg(vin, "Unbind CSI-2 %s from slot %u\n", subdev->name, i);
 		break;
 	}
+
+	mutex_unlock(&vin->group->lock);
 }
 
 static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
@@ -730,6 +740,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	unsigned int i;
 
+	mutex_lock(&vin->group->lock);
+
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
 		if (vin->group->csi[i].fwnode != asd->match.fwnode)
 			continue;
@@ -738,6 +750,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 		break;
 	}
 
+	mutex_unlock(&vin->group->lock);
+
 	return 0;
 }
 
@@ -752,6 +766,7 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
 				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = dev_get_drvdata(dev);
+	int ret = 0;
 
 	if (vep->base.port != 1 || vep->base.id >= RVIN_CSI_MAX)
 		return -EINVAL;
@@ -762,38 +777,48 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
 		return -ENOTCONN;
 	}
 
+	mutex_lock(&vin->group->lock);
+
 	if (vin->group->csi[vep->base.id].fwnode) {
 		vin_dbg(vin, "OF device %pOF already handled\n",
 			to_of_node(asd->match.fwnode));
-		return -ENOTCONN;
+		ret = -ENOTCONN;
+		goto out;
 	}
 
 	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
 
 	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
 		to_of_node(asd->match.fwnode), vep->base.id);
+out:
+	mutex_unlock(&vin->group->lock);
 
-	return 0;
+	return ret;
 }
 
 static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 {
-	unsigned int count = 0;
+	unsigned int count = 0, vin_mask = 0;
 	unsigned int i;
 	int ret;
 
 	mutex_lock(&vin->group->lock);
 
 	/* If not all VIN's are registered don't register the notifier. */
-	for (i = 0; i < RCAR_VIN_NUM; i++)
-		if (vin->group->vin[i])
+	for (i = 0; i < RCAR_VIN_NUM; i++) {
+		if (vin->group->vin[i]) {
 			count++;
+			vin_mask |= BIT(i);
+		}
+	}
 
 	if (vin->group->count != count) {
 		mutex_unlock(&vin->group->lock);
 		return 0;
 	}
 
+	mutex_unlock(&vin->group->lock);
+
 	v4l2_async_notifier_init(&vin->group->notifier);
 
 	/*
@@ -802,21 +827,17 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 	 * will only be registered once with the group notifier.
 	 */
 	for (i = 0; i < RCAR_VIN_NUM; i++) {
-		if (!vin->group->vin[i])
+		if (!(vin_mask & BIT(i)))
 			continue;
 
 		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
 				vin->group->vin[i]->dev, &vin->group->notifier,
 				sizeof(struct v4l2_async_subdev), 1,
 				rvin_mc_parse_of_endpoint);
-		if (ret) {
-			mutex_unlock(&vin->group->lock);
+		if (ret)
 			return ret;
-		}
 	}
 
-	mutex_unlock(&vin->group->lock);
-
 	if (list_empty(&vin->group->notifier.asd_list))
 		return 0;
 
-- 
2.20.1

