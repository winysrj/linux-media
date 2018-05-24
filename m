Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:53439 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969667AbeEXWCg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 18:02:36 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 3/9] media: rcar-vin: Create a group notifier
Date: Fri, 25 May 2018 00:02:13 +0200
Message-Id: <1527199339-7724-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As CSI-2 subdevices are shared between several VIN instances, a shared
notifier to collect the CSI-2 async subdevices is required. So far, the
rcar-vin driver used the notifier of the last VIN instance to probe but
with the forth-coming introduction of parallel input subdevices support
in mc-compliant code path, each VIN may register its own notifier if any
parallel subdevice is connected there.

To avoid registering a notifier twice (once for parallel subdev and one
for the CSI-2 subdevs) create a group notifier, shared by all the VIN
instances.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
v3 -> v4:
- Unregister and cleanup group notifier when un-registering the VIN
  instance whose v4l2_dev the notifier is associated to.
---
 drivers/media/platform/rcar-vin/rcar-core.c | 38 ++++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  5 ++--
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index bcf02de..d3aadf3 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -46,6 +46,8 @@
  */
 #define rvin_group_id_to_master(vin) ((vin) < 4 ? 0 : 4)
 
+#define v4l2_dev_to_vin(d)	container_of(d, struct rvin_dev, v4l2_dev)
+
 /* -----------------------------------------------------------------------------
  * Media Controller link notification
  */
@@ -583,7 +585,7 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
 
 static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 {
-	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	const struct rvin_group_route *route;
 	unsigned int i;
 	int ret;
@@ -649,7 +651,7 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 				     struct v4l2_subdev *subdev,
 				     struct v4l2_async_subdev *asd)
 {
-	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	unsigned int i;
 
 	for (i = 0; i < RCAR_VIN_NUM; i++)
@@ -673,7 +675,7 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 				   struct v4l2_subdev *subdev,
 				   struct v4l2_async_subdev *asd)
 {
-	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	unsigned int i;
 
 	mutex_lock(&vin->group->lock);
@@ -734,12 +736,6 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 
 	mutex_lock(&vin->group->lock);
 
-	/* If there already is a notifier something has gone wrong, bail out. */
-	if (WARN_ON(vin->group->notifier)) {
-		mutex_unlock(&vin->group->lock);
-		return -EINVAL;
-	}
-
 	/* If not all VIN's are registered don't register the notifier. */
 	for (i = 0; i < RCAR_VIN_NUM; i++)
 		if (vin->group->vin[i])
@@ -751,19 +747,16 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 	}
 
 	/*
-	 * Have all VIN's look for subdevices. Some subdevices will overlap
-	 * but the parser function can handle it, so each subdevice will
-	 * only be registered once with the notifier.
+	 * Have all VIN's look for CSI-2 subdevices. Some subdevices will
+	 * overlap but the parser function can handle it, so each subdevice
+	 * will only be registered once with the group notifier.
 	 */
-
-	vin->group->notifier = &vin->notifier;
-
 	for (i = 0; i < RCAR_VIN_NUM; i++) {
 		if (!vin->group->vin[i])
 			continue;
 
 		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
-				vin->group->vin[i]->dev, vin->group->notifier,
+				vin->group->vin[i]->dev, &vin->group->notifier,
 				sizeof(struct v4l2_async_subdev), 1,
 				rvin_mc_parse_of_endpoint);
 		if (ret) {
@@ -774,9 +767,12 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 
 	mutex_unlock(&vin->group->lock);
 
-	vin->group->notifier->ops = &rvin_group_notify_ops;
+	if (!vin->group->notifier.num_subdevs)
+		return 0;
 
-	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
+	vin->group->notifier.ops = &rvin_group_notify_ops;
+	ret = v4l2_async_notifier_register(&vin->v4l2_dev,
+					   &vin->group->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
 		return ret;
@@ -1114,8 +1110,10 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	if (vin->info->use_mc) {
 		mutex_lock(&vin->group->lock);
-		if (vin->group->notifier == &vin->notifier)
-			vin->group->notifier = NULL;
+		if (&vin->v4l2_dev == vin->group->notifier.v4l2_dev) {
+			v4l2_async_notifier_unregister(&vin->group->notifier);
+			v4l2_async_notifier_cleanup(&vin->group->notifier);
+		}
 		mutex_unlock(&vin->group->lock);
 		rvin_group_put(vin);
 	} else {
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 755ac3c..ebb480f7 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -225,8 +225,7 @@ struct rvin_dev {
  *
  * @lock:		protects the count, notifier, vin and csi members
  * @count:		number of enabled VIN instances found in DT
- * @notifier:		pointer to the notifier of a VIN which handles the
- *			groups async sub-devices.
+ * @notifier:		group notifier for CSI-2 async subdevices
  * @vin:		VIN instances which are part of the group
  * @csi:		array of pairs of fwnode and subdev pointers
  *			to all CSI-2 subdevices.
@@ -238,7 +237,7 @@ struct rvin_group {
 
 	struct mutex lock;
 	unsigned int count;
-	struct v4l2_async_notifier *notifier;
+	struct v4l2_async_notifier notifier;
 	struct rvin_dev *vin[RCAR_VIN_NUM];
 
 	struct {
-- 
2.7.4
