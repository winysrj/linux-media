Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15703 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2LaQEH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:04:07 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 09/15] s5p-fimc: Use pinctrl API for camera ports
 configuration
Date: Mon, 31 Dec 2012 17:03:07 +0100
Message-id: <1356969793-27268-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   25 ++++++++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    6 ++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 3ac6ea8..9e4ed9e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1123,6 +1123,25 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
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
 	struct device *dev = &pdev->dev;
@@ -1167,6 +1186,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
+	if (dev->of_node) {
+		ret = fimc_md_get_pinctrl(fmd);
+		if (ret < 0)
+			goto err_unlock;
+	}
+
 	if (fmd->pdev->dev.of_node)
 		ret = fimc_md_register_of_platform_entities(fmd);
 	else
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

