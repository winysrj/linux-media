Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8584 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517Ab3CHQqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:46:46 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC002AOP95NYK0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:45 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJC00BU5P8ZM870@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:44 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC v5 6/6] s5p-fimc: Use pinctrl API for camera ports
 configuration
Date: Fri, 08 Mar 2013 17:46:06 +0100
Message-id: <1362761166-5285-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
References: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before the camera ports can be used the pinmux needs to be configured
properly. This patch adds a function to set the camera ports pinctrl
to a default state within the media driver's probe().
The camera port(s) are then configured for the video bus operation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v4:
 - added more pinctrl states for camera port A and B normal operation
   and idle state (with CAMCLK output pin switched to high impedance
   state)

Changes since v3:
 - removed the "inactive" pinctrl state, it will be added later if required
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   12 +++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |   27 ++++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   11 ++++++++
 3 files changed, 50 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 88181d0..e3ac3fe 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -17,6 +17,15 @@ Required properties:
 
 - compatible : must be "samsung,fimc", "simple-bus"
 
+The pinctrl bindings defined in ../../pinctrl/pinctrl-bindings.txt must be used
+to define a required pinctrl state named "default" and optional pinctrl states:
+"idle", "active-a", active-b". These optional states can be used to switch the
+camera port pinmux at runtime. The "idle" state should configure both the camera
+ports A and B into high impedance state, especially the CAMCLK clock output
+should be inactive. For the "active-a" state the camera port A must be activated
+and the port B deactivated and for the state "active-b" it should be the other
+way around.
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -133,6 +142,9 @@ Example:
 		#size-cells = <1>;
 		status = "okay";
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&cam_port_a_clk_active>;
+
 		/* parallel camera ports */
 		parallel-ports {
 			/* camera A input */
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index b4c2ca8..590ed82 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1161,6 +1161,26 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
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
+
+	return pinctrl_select_state(pctl->pinctrl, pctl->state_default);
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1204,6 +1224,13 @@ static int fimc_md_probe(struct platform_device *pdev)
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

