Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47687 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbeEROlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:41:42 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 5/9] media: rcar-vin: Parse parallel input on Gen3
Date: Fri, 18 May 2018 16:40:41 +0200
Message-Id: <1526654445-10702-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar-vin driver so far had a mutually exclusive code path for
handling parallel and CSI-2 video input subdevices, with only the CSI-2
use case supporting media-controller. As we add support for parallel
inputs to Gen3 media-controller compliant code path now parse both port@0
and port@1, handling the media-controller use case in the parallel
bound/unbind notifier operations and delay notifier registration to the
last probing VIN instance in case we have links to setup between media
entities.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 114 +++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 0a35a98..745e8ee 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -397,6 +397,11 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
 	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
 	vin->parallel->sink_pad = ret < 0 ? 0 : ret;
 
+	vin->parallel->subdev = subdev;
+
+	if (vin->info->use_mc)
+		return 0;
+
 	/* Find compatible subdevices mbus format */
 	vin->mbus_code = 0;
 	code.index = 0;
@@ -422,46 +427,52 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
 	if (!vin->mbus_code) {
 		vin_err(vin, "Unsupported media bus format for %s\n",
 			subdev->name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto error_reset_subdev;
 	}
 
 	/* Read tvnorms */
 	ret = v4l2_subdev_call(subdev, video, g_tvnorms, &vin->vdev.tvnorms);
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
+		goto error_reset_subdev;
 
 	/* Read standard */
 	vin->std = V4L2_STD_UNKNOWN;
 	ret = v4l2_subdev_call(subdev, video, g_std, &vin->std);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
-		return ret;
+		goto error_reset_subdev;
 
 	/* Add the controls */
 	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
 	if (ret < 0)
-		return ret;
+		goto error_reset_subdev;
 
 	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, subdev->ctrl_handler,
 				    NULL);
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&vin->ctrl_handler);
-		return ret;
+		goto error_reset_subdev;
 	}
 
 	vin->vdev.ctrl_handler = &vin->ctrl_handler;
 
-	vin->parallel->subdev = subdev;
-
 	return 0;
+
+error_reset_subdev:
+	vin->parallel->subdev = NULL;
+
+	return ret;
 }
 
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
@@ -551,22 +562,26 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
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
 
+	/* If we use media-controller, notifier registration is post-poned. */
+	if (vin->info->use_mc)
+		return 0;
+
 	vin->notifier.ops = &rvin_parallel_notify_ops;
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
@@ -766,6 +781,30 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 
 	mutex_unlock(&vin->group->lock);
 
+	/*
+	 * Go and register all notifiers for parallel subdevs, and
+	 * the group notifier for CSI-2 subdevs, if any.
+	 */
+	for (i = 0; i < RCAR_VIN_NUM; i++) {
+		struct rvin_dev *ivin = vin->group->vin[i];
+		struct v4l2_async_notifier *inotifier;
+
+		if (!ivin)
+			continue;
+
+		inotifier = &ivin->notifier;
+		if (!inotifier->num_subdevs)
+			continue;
+
+		inotifier->ops = &rvin_parallel_notify_ops;
+		ret = v4l2_async_notifier_register(&ivin->v4l2_dev, inotifier);
+		if (ret < 0) {
+			vin_err(ivin,
+				"Notifier registration failed: %d\n", ret);
+			goto error_unregister_notifiers;
+		}
+	}
+
 	if (!vin->group->notifier.num_subdevs)
 		return 0;
 
@@ -773,25 +812,29 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev,
 					   &vin->group->notifier);
 	if (ret < 0) {
-		vin_err(vin, "Notifier registration failed\n");
+		vin_err(vin, "Notifier registration failed: %d\n", ret);
 		return ret;
 	}
 
 	return 0;
+
+error_unregister_notifiers:
+	for (i = 0; i < RCAR_VIN_NUM; i++) {
+		if (!vin->group->vin[i])
+			continue;
+
+		v4l2_async_notifier_unregister(&vin->group->vin[i]->notifier);
+	}
+
+	return ret;
 }
 
 static int rvin_mc_init(struct rvin_dev *vin)
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
@@ -1074,13 +1117,26 @@ static int rcar_vin_probe(struct platform_device *pdev)
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
+	ret = rvin_parallel_init(vin);
+	if (ret < 0 && ret != -ENOTCONN)
 		goto error;
 
+	ret = rvin_mc_init(vin);
+	if (ret)
+		return ret;
+
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
 
-- 
2.7.4
