Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19293 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaBTTl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:41:27 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 07/10] exynos4-is: Add clock provider for the SCLK_CAM clock
 outputs
Date: Thu, 20 Feb 2014 20:40:34 +0100
Message-id: <1392925237-31394-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds clock provider so the the SCLK_CAM0/1 output clocks
can be accessed by image sensor devices through the clk API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v3:
 - use clock-output-names DT property instead of hard coding names
   of registered clocks in the driver; first two entries of the
   clock-names property value are used to specify parent clocks of
   cam_{a,b}_clkout clocks, rather than hard coding it to sclk_cam{0,1}
   in the driver.
 - addressed issues pointed out in review by Mauro.

Changes since v2:
 - use 'camera' DT node drirectly as clock provider node, rather than
  creating additional clock-controller child node.
 - DT binding documentation moved to a separate patch.
---
 drivers/media/platform/exynos4-is/media-dev.c |  110 +++++++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.h |   19 ++++-
 2 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index c1bce17..dfc3131 100644
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
@@ -1437,6 +1439,103 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
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
+static void fimc_md_unregister_clk_provider(struct fimc_md *fmd)
+{
+	struct cam_clk_provider *cp = &fmd->clk_provider;
+	unsigned int i;
+
+	if (cp->of_node)
+		of_clk_del_provider(cp->of_node);
+
+	for (i = 0; i < cp->num_clocks; i++)
+		clk_unregister(cp->clks[i]);
+}
+
+static int fimc_md_register_clk_provider(struct fimc_md *fmd)
+{
+	struct cam_clk_provider *cp = &fmd->clk_provider;
+	struct device *dev = &fmd->pdev->dev;
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(cp->clks); i++) {
+		struct cam_clk *camclk = &cp->camclk[i];
+		struct clk_init_data init;
+
+		ret = of_property_read_string_index(dev->of_node,
+					"clock-output-names", i, &init.name);
+		if (ret < 0)
+			break;
+
+		ret = of_property_read_string_index(dev->of_node,
+					"clock-names", i, init.parent_names);
+		if (ret < 0)
+			break;
+
+		init.num_parents = 1;
+		init.ops = &cam_clk_ops;
+		init.flags = CLK_SET_RATE_PARENT;
+		camclk->hw.init = &init;
+		camclk->fmd = fmd;
+
+		cp->clks[i] = clk_register(NULL, &camclk->hw);
+		if (IS_ERR(cp->clks[i])) {
+			dev_err(dev, "failed to register clock: %s (%ld)\n",
+					init.name, PTR_ERR(cp->clks[i]));
+			ret = PTR_ERR(cp->clks[i]);
+			goto err;
+		}
+		cp->num_clocks++;
+	}
+
+	if (cp->num_clocks == 0) {
+		dev_warn(dev, "clk provider not registered\n");
+		return 0;
+	}
+
+	cp->clk_data.clks = cp->clks;
+	cp->clk_data.clk_num = cp->num_clocks;
+	cp->of_node = dev->of_node;
+	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
+				  &cp->clk_data);
+	if (ret == 0)
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
@@ -1464,16 +1563,24 @@ static int fimc_md_probe(struct platform_device *pdev)
 
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
@@ -1507,6 +1614,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
+
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret)
 		goto err_unlock;
@@ -1527,6 +1635,7 @@ err_clk:
 	media_device_unregister(&fmd->media_dev);
 err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
+	fimc_md_unregister_clk_provider(fmd);
 	return ret;
 }
 
@@ -1537,6 +1646,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 	if (!fmd)
 		return 0;
 
+	fimc_md_unregister_clk_provider(fmd);
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 62599fd..a88cee5 100644
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
@@ -122,13 +130,22 @@ struct fimc_md {
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
+		int num_clocks;
+	} clk_provider;
+
+	bool user_subdev_api;
 	spinlock_t slock;
 	struct list_head pipelines;
 };
-- 
1.7.9.5

