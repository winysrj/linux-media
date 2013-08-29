Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61879 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3H2JfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 05:35:07 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mturquette@linaro.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, arun.kk@samsung.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, a.hajda@samsung.com,
	kyungmin.park@samsung.com, t.figa@samsung.com,
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
	swarren@wwwdotorg.org, pawel.moll@arm.com, rob.herring@calxeda.com,
	galak@codeaurora.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v2 5/7] exynos4-is: Add clock provider for the external
 clocks
Date: Thu, 29 Aug 2013 11:34:06 +0200
Message-id: <1377768846-16145-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds clock provider to expose the sclk_cam0/1 clocks
for image sensor subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   17 ++-
 drivers/media/platform/exynos4-is/media-dev.c      |  115 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.h      |   18 ++-
 3 files changed, 147 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 96312f6..9f4d295 100644
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
+		       #clock-cells = <1>;
+		};
+
 		/* parallel camera ports */
 		parallel-ports {
 			/* camera A input */
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e327f45..6fba5f6 100644
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
@@ -1438,6 +1440,108 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static int cam_clk_prepare(struct clk_hw *hw)
+{
+	struct cam_clk *camclk = to_cam_clk(hw);
+	int ret;
+
+	if (camclk->fmd->pmf == NULL)
+		return -ENODEV;
+
+	ret = pm_runtime_get_sync(camclk->fmd->pmf);
+	return ret < 0 ? ret : 0;
+}
+
+static void cam_clk_unprepare(struct clk_hw *hw)
+{
+	struct cam_clk *camclk = to_cam_clk(hw);
+
+	if (camclk->fmd->pmf == NULL)
+		return;
+
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
+static void fimc_md_unregister_clk_provider(struct fimc_md *fmd)
+{
+	struct cam_clk_provider *cp = &fmd->clk_provider;
+	unsigned int i;
+
+	if (cp->of_node)
+		of_clk_del_provider(cp->of_node);
+
+	for (i = 0; i < ARRAY_SIZE(cp->clks); i++)
+		if (!IS_ERR(cp->clks[i]))
+			clk_unregister(cp->clks[i]);
+}
+
+static int fimc_md_register_clk_provider(struct fimc_md *fmd)
+{
+	struct cam_clk_provider *cp = &fmd->clk_provider;
+	struct device *dev = &fmd->pdev->dev;
+	struct device_node *node;
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(cp->clks); i++)
+		cp->clks[i] = ERR_PTR(-EINVAL);
+
+	node = of_get_child_by_name(dev->of_node, "clock-controller");
+	if (!node) {
+		dev_warn(dev, "clock-controller node at %s not found\n",
+					dev->of_node->full_name);
+		return 0;
+	}
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
+		struct cam_clk *camclk = &cp->camclk[i];
+		struct clk_init_data init;
+		char clk_name[16];
+		struct clk *clk;
+
+		snprintf(clk_name, sizeof(clk_name), "cam_clkout%d", i);
+
+		init.name = clk_name;
+		init.ops = &cam_clk_ops;
+		init.flags = CLK_SET_RATE_PARENT;
+		init.parent_names = &cam_clk_p_names[i];
+		init.num_parents = 1;
+		camclk->hw.init = &init;
+		camclk->fmd = fmd;
+
+		clk = clk_register(dev, &camclk->hw);
+		if (IS_ERR(clk)) {
+			dev_err(dev, "failed to register clock: %s (%ld)\n",
+						clk_name, PTR_ERR(clk));
+			ret = PTR_ERR(clk);
+			goto err;
+		}
+		cp->clks[i] = clk;
+	}
+
+	cp->clk_data.clks = cp->clks;
+	cp->clk_data.clk_num = i;
+	cp->of_node = node;
+
+	ret = of_clk_add_provider(node, of_clk_src_onecell_get,
+						&cp->clk_data);
+	if (!ret)
+		return 0;
+err:
+	fimc_md_unregister_clk_provider(fmd);
+	return ret;
+}
+#else
+#define fimc_md_register_clk_provider(fmd) (0)
+#define fimc_md_unregister_clk_provider(fmd) (0)
+#endif
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1465,16 +1569,24 @@ static int fimc_md_probe(struct platform_device *pdev)
 
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
@@ -1508,6 +1620,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
+
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret)
 		goto err_unlock;
@@ -1528,6 +1641,7 @@ err_clk:
 	media_device_unregister(&fmd->media_dev);
 err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
+	fimc_md_unregister_clk_provider(fmd);
 	return ret;
 }
 
@@ -1538,6 +1652,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 	if (!fmd)
 		return 0;
 
+	fimc_md_unregister_clk_provider(fmd);
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 62599fd..240ca71 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -10,6 +10,7 @@
 #define FIMC_MDEVICE_H_
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -89,6 +90,12 @@ struct fimc_sensor_info {
 	struct fimc_dev *host;
 };
 
+struct cam_clk {
+	struct clk_hw hw;
+	struct fimc_md *fmd;
+};
+#define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
+
 /**
  * struct fimc_md - fimc media device information
  * @csis: MIPI CSIS subdevs data
@@ -105,6 +112,7 @@ struct fimc_sensor_info {
  * @pinctrl: camera port pinctrl handle
  * @state_default: pinctrl default state handle
  * @state_idle: pinctrl idle state handle
+ * @cam_clk_provider: CAMCLK clock provider structure
  * @user_subdev_api: true if subdevs are not configured by the host driver
  * @slock: spinlock protecting @sensor array
  */
@@ -122,13 +130,21 @@ struct fimc_md {
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
+		struct cam_clk camclk[FIMC_MAX_CAMCLKS];
+	} clk_provider;
+
+	bool user_subdev_api;
 	spinlock_t slock;
 	struct list_head pipelines;
 };
-- 
1.7.9.5

