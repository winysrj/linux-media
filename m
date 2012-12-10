Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17347 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2LJTqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:46:45 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 06/12]  s5p-fimc: Use pinctrl API for camera ports
 configuration
Date: Mon, 10 Dec 2012 20:46:00 +0100
Message-id: <1355168766-6068-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before the camera ports can be used the pinmux needs to be configured
properly. This patch adds a function to get the pinctrl states and to
set default camera port pinmux state during the media driver's probe().
The camera port(s) are configured for video bus operation in this way.

"inactive" pinctrl state is intended for setting clock output pin(s)
into high impedance state when camera sensors are powered off.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   35 +++++++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    6 ++++
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index ee718af..74d16a3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1064,13 +1064,33 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
 static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 		   fimc_md_sysfs_show, fimc_md_sysfs_store);
 
+static int fimc_md_get_pinctrl(struct fimc_md *fmd)
+{
+	fmd->pinctl = devm_pinctrl_get_select_default(&fmd->pdev->dev);
+	if (IS_ERR(fmd->pinctl))
+		return PTR_ERR(fmd->pinctl);
+
+	fmd->pinctl_state_default = pinctrl_lookup_state(fmd->pinctl,
+						 PINCTRL_STATE_DEFAULT);
+	if (IS_ERR(fmd->pinctl_state_default))
+		return PTR_ERR(fmd->pinctl_state_default);
+
+	fmd->pinctl_state_idle = pinctrl_lookup_state(fmd->pinctl,
+						PINCTRL_STATE_INACTIVE);
+	if (IS_ERR(fmd->pinctl_state_idle))
+		return PTR_ERR(fmd->pinctl_state_idle);
+
+	return 0;
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct v4l2_device *v4l2_dev;
 	struct fimc_md *fmd;
 	int ret;
 
-	fmd = devm_kzalloc(&pdev->dev, sizeof(*fmd), GFP_KERNEL);
+	fmd = devm_kzalloc(dev, sizeof(*fmd), GFP_KERNEL);
 	if (!fmd)
 		return -ENOMEM;
 
@@ -1080,7 +1100,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
 	fmd->media_dev.link_notify = fimc_md_link_notify;
-	fmd->media_dev.dev = &pdev->dev;
+	fmd->media_dev.dev = dev;
 
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
@@ -1088,7 +1108,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
 
-	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
+	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
 		return ret;
@@ -1107,15 +1127,22 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
+	if (dev->of_node) {
+		ret = fimc_md_get_pinctrl(fmd);
+		if (ret < 0)
+			goto err_unlock;
+	}
+
 	ret = fimc_md_register_platform_entities(fmd);
 	if (ret)
 		goto err_unlock;
 
-	if (pdev->dev.platform_data || pdev->dev.of_node) {
+	if (dev->platform_data || dev->of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
 	}
+
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 1b7850c..89cecaa 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -10,6 +10,7 @@
 #define FIMC_MDEVICE_H_
 
 #include <linux/clk.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <media/media-device.h>
@@ -25,6 +26,8 @@
 #define FIMC_LITE_OF_NODE_NAME	"fimc_lite"
 #define CSIS_OF_NODE_NAME	"csis"
 
+#define PINCTRL_STATE_INACTIVE	"inactive"
+
 /* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
 #define GRP_ID_SENSOR		(1 << 8)
 #define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
@@ -85,6 +88,9 @@ struct fimc_md {
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
+	struct pinctrl *pinctl;
+	struct pinctrl_state *pinctl_state_default;
+	struct pinctrl_state *pinctl_state_idle;
 	bool user_subdev_api;
 	spinlock_t slock;
 };
-- 
1.7.9.5

