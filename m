Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:58469 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033192AbeEXWCi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 18:02:38 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 5/9] media: rcar-vin: Parse parallel input on Gen3
Date: Fri, 25 May 2018 00:02:15 +0200
Message-Id: <1527199339-7724-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar-vin driver so far had a mutually exclusive code path for
handling parallel and CSI-2 video input subdevices, with only the CSI-2
use case supporting media-controller. As we add support for parallel
inputs to Gen3 media-controller compliant code path now parse both port@0
and port@1, handling the media-controller use case in the parallel
bound/unbind notifier operations.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
v3 -> v4:
- Change the mc/parallel initialization order. Initialize mc first, then
  parallel
- As a consequence no need to delay parallel notifiers registration, the
  media controller is set up already when parallel input got parsed,
  this greatly simplify the group notifier complete callback.
---
 drivers/media/platform/rcar-vin/rcar-core.c | 56 ++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index a799684..29619c2 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -399,6 +399,11 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
 	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
 	vin->parallel->sink_pad = ret < 0 ? 0 : ret;
 
+	if (vin->info->use_mc) {
+		vin->parallel->subdev = subdev;
+		return 0;
+	}
+
 	/* Find compatible subdevices mbus format */
 	vin->mbus_code = 0;
 	code.index = 0;
@@ -460,10 +465,12 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
 static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
 {
 	rvin_v4l2_unregister(vin);
-	v4l2_ctrl_handler_free(&vin->ctrl_handler);
-
-	vin->vdev.ctrl_handler = NULL;
 	vin->parallel->subdev = NULL;
+
+	if (!vin->info->use_mc) {
+		v4l2_ctrl_handler_free(&vin->ctrl_handler);
+		vin->vdev.ctrl_handler = NULL;
+	}
 }
 
 static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
@@ -552,18 +559,18 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
 	return 0;
 }
 
-static int rvin_parallel_graph_init(struct rvin_dev *vin)
+static int rvin_parallel_init(struct rvin_dev *vin)
 {
 	int ret;
 
-	ret = v4l2_async_notifier_parse_fwnode_endpoints(
-		vin->dev, &vin->notifier,
-		sizeof(struct rvin_parallel_entity), rvin_parallel_parse_v4l2);
+	ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
+		vin->dev, &vin->notifier, sizeof(struct rvin_parallel_entity),
+		0, rvin_parallel_parse_v4l2);
 	if (ret)
 		return ret;
 
 	if (!vin->parallel)
-		return -ENODEV;
+		return -ENOTCONN;
 
 	vin_dbg(vin, "Found parallel subdevice %pOF\n",
 		to_of_node(vin->parallel->asd.match.fwnode));
@@ -784,14 +791,8 @@ static int rvin_mc_init(struct rvin_dev *vin)
 {
 	int ret;
 
-	vin->pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
-	if (ret)
-		return ret;
-
-	ret = rvin_group_get(vin);
-	if (ret)
-		return ret;
+	if (!vin->info->use_mc)
+		return 0;
 
 	ret = rvin_mc_parse_of_graph(vin);
 	if (ret)
@@ -1074,11 +1075,24 @@ static int rcar_vin_probe(struct platform_device *pdev)
 		return ret;
 
 	platform_set_drvdata(pdev, vin);
-	if (vin->info->use_mc)
-		ret = rvin_mc_init(vin);
-	else
-		ret = rvin_parallel_graph_init(vin);
-	if (ret < 0)
+
+	if (vin->info->use_mc) {
+		vin->pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
+		if (ret)
+			return ret;
+
+		ret = rvin_group_get(vin);
+		if (ret)
+			return ret;
+	}
+
+	ret = rvin_mc_init(vin);
+	if (ret)
+		return ret;
+
+	ret = rvin_parallel_init(vin);
+	if (ret < 0 && ret != -ENOTCONN)
 		goto error;
 
 	pm_suspend_ignore_children(&pdev->dev, true);
-- 
2.7.4
