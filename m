Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63460 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaCFQWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 11:22:19 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 07/10] exynos4-is: Add clock provider for the SCLK_CAM clock
 outputs
Date: Thu, 06 Mar 2014 17:20:16 +0100
Message-id: <1394122819-9582-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds clock provider so the the SCLK_CAM0/1 output clocks
can be accessed by image sensor devices through the clk API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v5:
 - added a missing check if clocks provider is registered, in order
   to prevent control of the clock at the host interface side in case
   when clock is exposed through the clk API and handled by the sensor
   drivers. This allows new kernels to work with old DTB (old kernels
   will work with new DTB as well).

Changes since v4:
 - retrieve clk parent name through __clk_get_name() on the input
   clock instead of improperly using clock-names (Mark).

Changes since v3:
 - use clock-output-names DT property instead of hard coding names
   of registered clocks in the driver; first two entries of the
   clock-names property value are used to specify parent clocks of
   cam_{a,b}_clkout clocks, rather than hard coding it to sclk_cam{0,1}
   in the driver;
 - addressed issues pointed out in review (Mauro).

Changes since v2:
 - use 'camera' DT node drirectly as clock provider node, rather than
  creating additional clock-controller child node.
 - DT binding documentation moved to a separate patch.
---
 drivers/media/platform/exynos4-is/media-dev.c |  118 +++++++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.h |   19 +++-
 2 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index c1bce17..f047a9f 100644
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
@@ -1276,6 +1278,14 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 	struct fimc_source_info *si = v4l2_get_subdev_hostdata(sd);
 	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);

+	/*
+	 * If there is a clock provider registered the sensors will
+	 * handle their clock themselves, no need to control it on
+	 * the host interface side.
+	 */
+	if (fmd->clk_provider.num_clocks > 0)
+		return 0;
+
 	return __fimc_md_set_camclk(fmd, si, on);
 }

@@ -1437,6 +1447,103 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
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
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
+		struct cam_clk *camclk = &cp->camclk[i];
+		struct clk_init_data init;
+		const char *p_name;
+
+		ret = of_property_read_string_index(dev->of_node,
+					"clock-output-names", i, &init.name);
+		if (ret < 0)
+			break;
+
+		p_name = __clk_get_name(fmd->camclk[i].clock);
+
+		/* It's safe since clk_register() will duplicate the string. */
+		init.parent_names = &p_name;
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
@@ -1464,16 +1571,24 @@ static int fimc_md_probe(struct platform_device *pdev)

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
@@ -1507,6 +1622,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
+
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret)
 		goto err_unlock;
@@ -1527,6 +1643,7 @@ err_clk:
 	media_device_unregister(&fmd->media_dev);
 err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
+	fimc_md_unregister_clk_provider(fmd);
 	return ret;
 }

@@ -1537,6 +1654,7 @@ static int fimc_md_remove(struct platform_device *pdev)
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

