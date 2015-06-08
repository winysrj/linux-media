Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54541 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbbFHJDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 05:03:19 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v10 8/8] exynos4-is: Add support for v4l2-flash subdevs
Date: Mon, 08 Jun 2015 11:02:25 +0200
Message-id: <1433754145-12765-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com>
References: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for external v4l2-flash devices.
The support includes parsing "camera-flashes" DT property
and asynchronous sub-device registration.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   75 ++++++++++++++++++++++++-
 drivers/media/platform/exynos4-is/media-dev.h |    4 ++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e3d7b70..e387fd2 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -455,6 +455,63 @@ rpm_put:
 	return ret;
 }
 
+static int fimc_md_register_flash_entities(struct fimc_md *fmd)
+{
+	struct device_node *parent = fmd->pdev->dev.of_node, *np_sensor,
+		*np_flash;
+	struct v4l2_async_notifier *notifier = &fmd->subdev_notifier;
+	struct device *dev = &fmd->pdev->dev;
+	struct v4l2_async_subdev *asd;
+	int i, j, num_flashes = 0, num_elems;
+
+	num_elems = of_property_count_u32_elems(parent,
+						"samsung,camera-flashes");
+	/* samsung,camera-flashes property is optional */
+	if (num_elems < 0)
+		return 0;
+
+	/* samsung,camera-flashes array must have even number of elements */
+	if ((num_elems & 1) || (num_elems > FIMC_MAX_SENSORS * 2))
+		return -EINVAL;
+
+	for (i = 0; i < num_elems; i += 2) {
+		/*
+		 * The pair of camera sensor and flash LED phandles reflects
+		 * the physical connection on the board, which allows for the
+		 * camera sensor to strobe the flash by raising a hardware pin.
+		 * This property just describes the association.
+		 */
+		np_sensor = of_parse_phandle(parent,
+					     "samsung,camera-flashes", i);
+
+		for (j = 0; j < fmd->num_sensors; j++)
+			if (fmd->async_subdevs.sensors[j].match.of.node ==
+			    np_sensor)
+				break;
+
+		of_node_put(np_sensor);
+
+		/*
+		 * If the camera sensor phandle isn't known to the media device
+		 * controller, then raise a warning only.
+		 */
+		if (j == fmd->num_sensors)
+			dev_warn(dev, "sensor verification failed for a flash\n");
+
+		np_flash = of_parse_phandle(parent, "samsung,camera-flashes",
+						i + 1);
+
+		asd = &fmd->async_subdevs.flashes[num_flashes++];
+		asd->match_type = V4L2_ASYNC_MATCH_OF;
+		asd->match.of.node = np_flash;
+		notifier->subdevs[notifier->num_subdevs++] = asd;
+
+		of_node_put(np_flash);
+	}
+
+	return 0;
+}
+
 static int __of_get_csis_id(struct device_node *np)
 {
 	u32 reg = 0;
@@ -1280,6 +1337,15 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 	struct fimc_sensor_info *si = NULL;
 	int i;
 
+	/*
+	 * Flash sub-devices are controlled independently of ISP, and thus
+	 * verify only that the sub-device being matched was previously
+	 * registered.
+	 */
+	for (i = 0; i < ARRAY_SIZE(async_subdevs->flashes); i++)
+		if (&async_subdevs->flashes[i] == asd)
+			return 0;
+
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(async_subdevs->sensors); i++)
 		if (fmd->sensor[i].asd == asd)
@@ -1326,13 +1392,18 @@ static int fimc_md_register_async_entities(struct fimc_md *fmd)
 {
 	struct device *dev = fmd->media_dev.dev;
 	struct v4l2_async_notifier *notifier = &fmd->subdev_notifier;
+	int ret;
 
-	notifier->subdevs = devm_kcalloc(dev, FIMC_MAX_SENSORS,
+	notifier->subdevs = devm_kcalloc(dev, FIMC_MAX_ASYNC_ENTITIES,
 					sizeof(*notifier->subdevs), GFP_KERNEL);
 	if (!notifier->subdevs)
 		return -ENOMEM;
 
-	return fimc_md_register_sensor_entities(fmd);
+	ret = fimc_md_register_sensor_entities(fmd);
+	if (ret)
+		return -EINVAL;
+
+	return fimc_md_register_flash_entities(fmd);
 }
 
 static int fimc_md_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index ff6d020..be9205c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -33,7 +33,10 @@
 #define PINCTRL_STATE_IDLE	"idle"
 
 #define FIMC_MAX_SENSORS	4
+#define FIMC_MAX_FLASHES	4
+#define FIMC_MAX_ASYNC_ENTITIES	(FIMC_MAX_SENSORS + FIMC_MAX_FLASHES)
 #define FIMC_MAX_CAMCLKS	2
+
 #define DEFAULT_SENSOR_CLK_FREQ	24000000U
 
 /* LCD/ISP Writeback clocks (PIXELASYNCMx) */
@@ -95,6 +98,7 @@ struct fimc_sensor_info {
 
 struct fimc_async_subdevs {
 	struct v4l2_async_subdev sensors[FIMC_MAX_SENSORS];
+	struct v4l2_async_subdev flashes[FIMC_MAX_FLASHES];
 };
 
 struct cam_clk {
-- 
1.7.9.5

