Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54288 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbcHOPHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:07:16 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 04/10] [media] rcar-vin: rename entity to digital
Date: Mon, 15 Aug 2016 17:06:29 +0200
Message-Id: <20160815150635.22637-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When Gen3 support is added to the driver more then one possible video
source entity will be possible. Knowing that the name entity is a bad
one, rename it to digital since it will deal with the digital input
source.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 46 ++++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  6 ++--
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 4b2007b..a1eb26b 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -60,7 +60,7 @@ static int rvin_mbus_supported(struct rvin_dev *vin)
 	return false;
 }
 
-static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
+static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 	int ret;
@@ -79,31 +79,31 @@ static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
 	return rvin_v4l2_probe(vin);
 }
 
-static void rvin_graph_notify_unbind(struct v4l2_async_notifier *notifier,
-				     struct v4l2_subdev *sd,
-				     struct v4l2_async_subdev *asd)
+static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
+				       struct v4l2_subdev *subdev,
+				       struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	rvin_v4l2_remove(vin);
 }
 
-static int rvin_graph_notify_bound(struct v4l2_async_notifier *notifier,
-				   struct v4l2_subdev *subdev,
-				   struct v4l2_async_subdev *asd)
+static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	vin_dbg(vin, "subdev %s bound\n", subdev->name);
 
-	vin->entity.entity = &subdev->entity;
-	vin->entity.subdev = subdev;
+	vin->digital.entity = &subdev->entity;
+	vin->digital.subdev = subdev;
 
 	return 0;
 }
 
-static int rvin_graph_parse(struct rvin_dev *vin,
-			    struct device_node *node)
+static int rvin_digital_parse(struct rvin_dev *vin,
+			      struct device_node *node)
 {
 	struct device_node *remote;
 	struct device_node *ep = NULL;
@@ -131,10 +131,10 @@ static int rvin_graph_parse(struct rvin_dev *vin,
 		}
 
 		/* Remote node to connect */
-		if (!vin->entity.node) {
-			vin->entity.node = remote;
-			vin->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
-			vin->entity.asd.match.of.node = remote;
+		if (!vin->digital.node) {
+			vin->digital.node = remote;
+			vin->digital.asd.match_type = V4L2_ASYNC_MATCH_OF;
+			vin->digital.asd.match.of.node = remote;
 			ret++;
 		}
 	}
@@ -144,13 +144,13 @@ static int rvin_graph_parse(struct rvin_dev *vin,
 	return ret;
 }
 
-static int rvin_graph_init(struct rvin_dev *vin)
+static int rvin_digital_init(struct rvin_dev *vin)
 {
 	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
 	/* Parse the graph to extract a list of subdevice DT nodes. */
-	ret = rvin_graph_parse(vin, vin->dev->of_node);
+	ret = rvin_digital_parse(vin, vin->dev->of_node);
 	if (ret < 0) {
 		vin_err(vin, "Graph parsing failed\n");
 		goto done;
@@ -173,13 +173,13 @@ static int rvin_graph_init(struct rvin_dev *vin)
 		goto done;
 	}
 
-	subdevs[0] = &vin->entity.asd;
+	subdevs[0] = &vin->digital.asd;
 
 	vin->notifier.subdevs = subdevs;
 	vin->notifier.num_subdevs = 1;
-	vin->notifier.bound = rvin_graph_notify_bound;
-	vin->notifier.unbind = rvin_graph_notify_unbind;
-	vin->notifier.complete = rvin_graph_notify_complete;
+	vin->notifier.bound = rvin_digital_notify_bound;
+	vin->notifier.unbind = rvin_digital_notify_unbind;
+	vin->notifier.complete = rvin_digital_notify_complete;
 
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
@@ -192,7 +192,7 @@ static int rvin_graph_init(struct rvin_dev *vin)
 done:
 	if (ret < 0) {
 		v4l2_async_notifier_unregister(&vin->notifier);
-		of_node_put(vin->entity.node);
+		of_node_put(vin->digital.node);
 	}
 
 	return ret;
@@ -289,7 +289,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rvin_graph_init(vin);
+	ret = rvin_digital_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index b9274132..93daa05 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -90,7 +90,7 @@ struct rvin_graph_entity {
  * @src_pad_idx:	source pad index for media controller drivers
  * @ctrl_handler:	V4L2 control handler
  * @notifier:		V4L2 asynchronous subdevs notifier
- * @entity:		entity in the DT for subdevice
+ * @digital:		entity in the DT for local digital subdevice
  *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
@@ -120,7 +120,7 @@ struct rvin_dev {
 	int src_pad_idx;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
-	struct rvin_graph_entity entity;
+	struct rvin_graph_entity digital;
 
 	struct mutex lock;
 	struct vb2_queue queue;
@@ -139,7 +139,7 @@ struct rvin_dev {
 	struct v4l2_rect compose;
 };
 
-#define vin_to_source(vin)		vin->entity.subdev
+#define vin_to_source(vin)		vin->digital.subdev
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
-- 
2.9.2

