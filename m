Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35099 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbFHJDO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 05:03:14 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v10 6/8] exynos4-is: Improve the mechanism of async subdevs
 verification
Date: Mon, 08 Jun 2015 11:02:23 +0200
Message-id: <1433754145-12765-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com>
References: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid verifying bound async sensor sub-devices by their of_nodes,
which duplicates v4l2-async functionality, in favour of matching
them by the corresponding struct v4l2_async_subdev. The structures
are now being aggregated in the newly introduced struct fimc_async_subdevs
which allows for categorizing async sub-devices by their type upon
DT node parsing and recognizing the type easily when they're being bound.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   34 +++++++++++++++++++------
 drivers/media/platform/exynos4-is/media-dev.h |    8 ++++--
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a..e3d7b70 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -331,6 +331,8 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 				   unsigned int index)
 {
 	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
+	struct v4l2_async_notifier *notifier = &fmd->subdev_notifier;
+	struct v4l2_async_subdev *asd;
 	struct device_node *rem, *ep, *np;
 	struct v4l2_of_endpoint endpoint;
 
@@ -387,9 +389,11 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
 		return -EINVAL;
 
-	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
-	fmd->sensor[index].asd.match.of.node = rem;
-	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
+	asd = &fmd->async_subdevs.sensors[index];
+	asd->match_type = V4L2_ASYNC_MATCH_OF;
+	asd->match.of.node = rem;
+	notifier->subdevs[notifier->num_subdevs++] = asd;
+	fmd->sensor[index].asd = asd;
 
 	fmd->num_sensors++;
 
@@ -1272,12 +1276,13 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 				 struct v4l2_async_subdev *asd)
 {
 	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
+	struct fimc_async_subdevs *async_subdevs = &fmd->async_subdevs;
 	struct fimc_sensor_info *si = NULL;
 	int i;
 
 	/* Find platform data for this sensor subdev */
-	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
+	for (i = 0; i < ARRAY_SIZE(async_subdevs->sensors); i++)
+		if (fmd->sensor[i].asd == asd)
 			si = &fmd->sensor[i];
 
 	if (si == NULL)
@@ -1317,6 +1322,19 @@ unlock:
 	return ret;
 }
 
+static int fimc_md_register_async_entities(struct fimc_md *fmd)
+{
+	struct device *dev = fmd->media_dev.dev;
+	struct v4l2_async_notifier *notifier = &fmd->subdev_notifier;
+
+	notifier->subdevs = devm_kcalloc(dev, FIMC_MAX_SENSORS,
+					sizeof(*notifier->subdevs), GFP_KERNEL);
+	if (!notifier->subdevs)
+		return -ENOMEM;
+
+	return fimc_md_register_sensor_entities(fmd);
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1379,7 +1397,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = fimc_md_register_sensor_entities(fmd);
+	ret = fimc_md_register_async_entities(fmd);
 	if (ret) {
 		mutex_unlock(&fmd->media_dev.graph_mutex);
 		goto err_m_ent;
@@ -1402,8 +1420,6 @@ static int fimc_md_probe(struct platform_device *pdev)
 	}
 
 	if (fmd->num_sensors > 0) {
-		fmd->subdev_notifier.subdevs = fmd->async_subdevs;
-		fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
 		fmd->subdev_notifier.bound = subdev_notifier_bound;
 		fmd->subdev_notifier.complete = subdev_notifier_complete;
 		fmd->num_sensors = 0;
@@ -1412,6 +1428,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 						&fmd->subdev_notifier);
 		if (ret)
 			goto err_clk_p;
+	} else {
+		devm_kfree(dev, fmd->subdev_notifier.subdevs);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 0321454..ff6d020 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -88,11 +88,15 @@ struct fimc_camclk_info {
  */
 struct fimc_sensor_info {
 	struct fimc_source_info pdata;
-	struct v4l2_async_subdev asd;
+	struct v4l2_async_subdev *asd;
 	struct v4l2_subdev *subdev;
 	struct fimc_dev *host;
 };
 
+struct fimc_async_subdevs {
+	struct v4l2_async_subdev sensors[FIMC_MAX_SENSORS];
+};
+
 struct cam_clk {
 	struct clk_hw hw;
 	struct fimc_md *fmd;
@@ -149,7 +153,7 @@ struct fimc_md {
 	} clk_provider;
 
 	struct v4l2_async_notifier subdev_notifier;
-	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
+	struct fimc_async_subdevs async_subdevs;
 
 	bool user_subdev_api;
 	spinlock_t slock;
-- 
1.7.9.5

