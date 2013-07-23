Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3GWSlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:41:31 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 4/6] exynos4-is: Add clock provider for the external
 clocks
Date: Tue, 23 Jul 2013 20:39:35 +0200
Message-id: <1374604777-15523-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds clock provider to expose the sclk_cam0/1 clocks
for image sensor subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   17 +++-
 drivers/media/platform/exynos4-is/media-dev.c      |   92 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.h      |   19 +++-
 3 files changed, 125 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 96312f6..04a2b87 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -91,6 +91,15 @@ Optional properties
 - samsung,camclk-out : specifies clock output for remote sensor,
 		       0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;
 
+'clock-controller' node (optional)
+----------------------------------
+
+The purpose of this node is to define a clock provider for external image
+sensors and link any of the CAM_?_CLKOUT clock outputs with related external
+clock consumer device. Properties specific to this node are described in
+../clock/clock-bindings.txt.
+
+
 Image sensor nodes
 ------------------
 
@@ -114,7 +123,7 @@ Example:
 			vddio-supply = <...>;
 
 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camclk 1>;
 			clock-names = "mclk";
 
 			port {
@@ -135,7 +144,7 @@ Example:
 			vddio-supply = <...>;
 
 			clock-frequency = <24000000>;
-			clocks = <...>;
+			clocks = <&camclk 0>;
 			clock-names = "mclk";
 
 			port {
@@ -156,6 +165,10 @@ Example:
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
 
+		camclk: clock-controller {
+		       #clock-cells = 1;
+		};
+
 		/* parallel camera ports */
 		parallel-ports {
 			/* camera A input */
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 41366fe..346e1e0 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -11,6 +11,8 @@
  */
 
 #include <linux/bug.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
@@ -1438,6 +1440,86 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+struct cam_clk {
+	struct clk_hw hw;
+	struct fimc_md *fmd;
+};
+#define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
+
+static int cam_clk_prepare(struct clk_hw *hw)
+{
+	struct cam_clk *camclk = to_cam_clk(hw);
+	int ret = pm_runtime_get_sync(camclk->fmd->pmf);
+
+	return ret < 0 ? ret : 0;
+}
+
+static void cam_clk_unprepare(struct clk_hw *hw)
+{
+	struct cam_clk *camclk = to_cam_clk(hw);
+	pm_runtime_put_sync(camclk->fmd->pmf);
+}
+
+static const struct clk_ops cam_clk_ops = {
+	.prepare = cam_clk_prepare,
+	.unprepare = cam_clk_unprepare,
+};
+
+static const char *cam_clk_p_names[] = { "sclk_cam0", "sclk_cam1" };
+
+static int fimc_md_register_clk_provider(struct fimc_md *fmd)
+{
+	struct cam_clk_provider *clk_provider = &fmd->clk_provider;
+	struct device *dev = &fmd->pdev->dev;
+	struct device_node *node;
+	unsigned int nclocks;
+
+	node = of_get_child_by_name(dev->of_node, "clock-controller");
+	if (!node) {
+		dev_warn(dev, "clock-controller node at %s not found\n",
+					dev->of_node->full_name);
+		return 0;
+	}
+	/* Instantiate the clocks */
+	for (nclocks = 0; nclocks < FIMC_MAX_CAMCLKS; nclocks++) {
+		struct clk_init_data init;
+		char clk_name[16];
+		struct clk *clk;
+		struct cam_clk *camclk;
+
+		camclk = devm_kzalloc(dev, sizeof(*camclk), GFP_KERNEL);
+		if (!camclk)
+			return -ENOMEM;
+
+		snprintf(clk_name, sizeof(clk_name), "cam_clkout%d", nclocks);
+
+		init.name = clk_name;
+		init.ops = &cam_clk_ops;
+		init.flags = CLK_SET_RATE_PARENT;
+		init.parent_names = &cam_clk_p_names[nclocks];
+		init.num_parents = 1;
+		camclk->hw.init = &init;
+		camclk->fmd = fmd;
+
+		clk = devm_clk_register(dev, &camclk->hw);
+		if (IS_ERR(clk)) {
+			kfree(camclk);
+			return PTR_ERR(clk);
+		}
+		clk_provider->clks[nclocks] = clk;
+	}
+
+	clk_provider->clk_data.clks = clk_provider->clks;
+	clk_provider->clk_data.clk_num = nclocks;
+
+	return of_clk_add_provider(node, of_clk_src_onecell_get,
+					&clk_provider->clk_data);
+}
+#else
+#define fimc_md_register_clk_provider(fmd) (0)
+#endif
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1465,16 +1547,24 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
 
+	ret = fimc_md_register_clk_provider(fmd);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "clock provider registration failed\n");
+		return ret;
+	}
+
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
 		return ret;
 	}
+
 	ret = media_device_register(&fmd->media_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
 		goto err_md;
 	}
+
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
 		goto err_clk;
@@ -1508,6 +1598,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
+
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret)
 		goto err_unlock;
@@ -1528,6 +1619,7 @@ err_clk:
 	media_device_unregister(&fmd->media_dev);
 err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
+	fimc_md_unregister_clk_provider(fmd);
 	return ret;
 }
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 62599fd..09cc6ca 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -10,6 +10,7 @@
 #define FIMC_MDEVICE_H_
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -105,6 +106,7 @@ struct fimc_sensor_info {
  * @pinctrl: camera port pinctrl handle
  * @state_default: pinctrl default state handle
  * @state_idle: pinctrl idle state handle
+ * @cam_clk_provider: CAMCLK clock provider structure
  * @user_subdev_api: true if subdevs are not configured by the host driver
  * @slock: spinlock protecting @sensor array
  */
@@ -122,13 +124,20 @@ struct fimc_md {
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
+
 	struct fimc_pinctrl {
 		struct pinctrl *pinctrl;
 		struct pinctrl_state *state_default;
 		struct pinctrl_state *state_idle;
 	} pinctl;
-	bool user_subdev_api;
 
+	struct cam_clk_provider {
+		struct clk *clks[FIMC_MAX_CAMCLKS];
+		struct clk_onecell_data clk_data;
+		struct device_node *of_node;
+	} clk_provider;
+
+	bool user_subdev_api;
 	spinlock_t slock;
 	struct list_head pipelines;
 };
@@ -163,8 +172,16 @@ static inline bool fimc_md_is_isp_available(struct device_node *node)
 	node = of_get_child_by_name(node, FIMC_IS_OF_NODE_NAME);
 	return node ? of_device_is_available(node) : false;
 }
+
+static inline void fimc_md_unregister_clk_provider(struct fimc_md *fmd)
+{
+	if (fmd->clk_provider.of_node)
+		of_clk_del_provider(fmd->clk_provider.of_node);
+}
 #else
+
 #define fimc_md_is_isp_available(node) (false)
+#define fimc_md_unregister_clk_provider(fmd) (0)
 #endif /* CONFIG_OF */
 
 static inline struct v4l2_subdev *__fimc_md_get_subdev(
-- 
1.7.9.5

