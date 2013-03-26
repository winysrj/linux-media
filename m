Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:16929 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524Ab3CZQki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:40:38 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 6/6] s5p-fimc: Use pinctrl API for camera ports configuration
Date: Tue, 26 Mar 2013 17:39:58 +0100
Message-id: <1364315998-19372-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
References: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before the camera ports can be used the pinmux needs to be configured
properly. This patch adds a function to set the camera ports pinctrl
to a default state within the media driver's probe().
The camera port(s) are then configured for the video bus operation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v5:
 - None.

Changes since v4:
 - Added more pinctrl states for camera port A and B normal operation
   and idle state (with CAMCLK output pin switched to high impedance
   state).

Changes since v3:
 - Removed the "inactive" pinctrl state, it will be added later if
   required.
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   12 +++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |   26 ++++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   11 +++++++++
 3 files changed, 49 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 7617b93..b379822 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -21,6 +21,15 @@ Required properties:
 - clock-names	: must contain "fimc", "sclk_fimc" entries, matching entries
 		  in the clocks property.
 
+The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
+to define a required pinctrl state named "default" and optional pinctrl states:
+"idle", "active-a", active-b". These optional states can be used to switch the
+camera port pinmux at runtime. The "idle" state should configure both the camera
+ports A and B into high impedance state, especially the CAMCLK clock output
+should be inactive. For the "active-a" state the camera port A must be activated
+and the port B deactivated and for the state "active-b" it should be the other
+way around.
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -147,6 +156,9 @@ Example:
 		#size-cells = <1>;
 		status = "okay";
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&cam_port_a_clk_active>;
+
 		/* parallel camera ports */
 		parallel-ports {
 			/* camera A input */
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index d6d38b9..b689166 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1171,6 +1171,25 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
 static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 		   fimc_md_sysfs_show, fimc_md_sysfs_store);
 
+static int fimc_md_get_pinctrl(struct fimc_md *fmd)
+{
+	struct device *dev = &fmd->pdev->dev;
+	struct fimc_pinctrl *pctl = &fmd->pinctl;
+
+	pctl->pinctrl = devm_pinctrl_get(dev);
+	if (IS_ERR(pctl->pinctrl))
+		return PTR_ERR(pctl->pinctrl);
+
+	pctl->state_default = pinctrl_lookup_state(pctl->pinctrl,
+					PINCTRL_STATE_DEFAULT);
+	if (IS_ERR(pctl->state_default))
+		return PTR_ERR(pctl->state_default);
+
+	pctl->state_idle = pinctrl_lookup_state(pctl->pinctrl,
+					PINCTRL_STATE_IDLE);
+	return 0;
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1214,6 +1233,13 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
+	ret = fimc_md_get_pinctrl(fmd);
+	if (ret < 0) {
+		if (ret != EPROBE_DEFER)
+			dev_err(dev, "Failed to get pinctrl: %d\n", ret);
+		goto err_unlock;
+	}
+
 	if (dev->of_node)
 		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
 	else
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index b6ceb59..5d6146e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/pinctrl/consumer.h>
 #include <media/media-device.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
@@ -26,6 +27,8 @@
 #define FIMC_IS_OF_NODE_NAME	"fimc-is"
 #define CSIS_OF_NODE_NAME	"csis"
 
+#define PINCTRL_STATE_IDLE	"idle"
+
 /* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
 #define GRP_ID_SENSOR		(1 << 8)
 #define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
@@ -73,6 +76,9 @@ struct fimc_sensor_info {
  * @media_dev: top level media device
  * @v4l2_dev: top level v4l2_device holding up the subdevs
  * @pdev: platform device this media device is hooked up into
+ * @pinctrl: camera port pinctrl handle
+ * @state_default: pinctrl default state handle
+ * @state_idle: pinctrl idle state handle
  * @user_subdev_api: true if subdevs are not configured by the host driver
  * @slock: spinlock protecting @sensor array
  */
@@ -86,6 +92,11 @@ struct fimc_md {
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
+	struct fimc_pinctrl {
+		struct pinctrl *pinctrl;
+		struct pinctrl_state *state_default;
+		struct pinctrl_state *state_idle;
+	} pinctl;
 	bool user_subdev_api;
 	spinlock_t slock;
 };
-- 
1.7.9.5

