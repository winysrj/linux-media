Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50869 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755409AbeE2Is3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:48:29 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 07/10] media: rcar-vin: Link parallel input media entities
Date: Tue, 29 May 2018 10:48:05 +0200
Message-Id: <1527583688-314-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When running with media-controller link the parallel input
media entities with the VIN entities at 'complete' callback time.

To create media links the v4l2_device should be registered first.
Check if the device is already registered, to avoid double registrations.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index c1d6feb..66066a0 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -476,6 +476,8 @@ static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
 static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct media_entity *source;
+	struct media_entity *sink;
 	int ret;
 
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
@@ -484,7 +486,26 @@ static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	return rvin_v4l2_register(vin);
+	if (!video_is_registered(&vin->vdev)) {
+		ret = rvin_v4l2_register(vin);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (!vin->info->use_mc)
+		return 0;
+
+	/* If we're running with media-controller, link the subdevs. */
+	source = &vin->parallel->subdev->entity;
+	sink = &vin->vdev.entity;
+
+	ret = media_create_pad_link(source, vin->parallel->source_pad,
+				    sink, vin->parallel->sink_pad, 0);
+	if (ret)
+		vin_err(vin, "Error adding link from %s to %s: %d\n",
+			source->name, sink->name, ret);
+
+	return ret;
 }
 
 static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
@@ -610,7 +631,8 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 
 	/* Register all video nodes for the group. */
 	for (i = 0; i < RCAR_VIN_NUM; i++) {
-		if (vin->group->vin[i]) {
+		if (vin->group->vin[i] &&
+		    !video_is_registered(&vin->group->vin[i]->vdev)) {
 			ret = rvin_v4l2_register(vin->group->vin[i]);
 			if (ret)
 				return ret;
-- 
2.7.4
