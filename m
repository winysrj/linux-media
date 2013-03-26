Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50665 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3CZSPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:15:03 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 6/7] s5p-fimc: Add fimc-is subdevs registration
Date: Tue, 26 Mar 2013 19:14:22 +0100
Message-id: <1364321663-21010-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364321663-21010-1-git-send-email-s.nawrocki@samsung.com>
References: <1364321663-21010-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows to register FIMC-IS device represented by FIMC-IS-ISP
subdev to the top level media device driver. The use_isp platform data
structure field allows to select whether the fimc-is ISP subdev should
be tried to be registered or not.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   37 +++++++++++++++++++++++--
 drivers/media/platform/exynos4-is/media-dev.h |   13 +++++++++
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 6048290..5e1c28e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -32,6 +32,7 @@
 
 #include "media-dev.h"
 #include "fimc-core.h"
+#include "fimc-is.h"
 #include "fimc-lite.h"
 #include "mipi-csis.h"
 
@@ -85,9 +86,11 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 		case GRP_ID_FIMC:
 			/* No need to control FIMC subdev through subdev ops */
 			break;
+		case GRP_ID_FIMC_IS:
+			p->subdevs[IDX_IS_ISP] = sd;
+			break;
 		default:
-			pr_warn("%s: Unknown subdev grp_id: %#x\n",
-				__func__, sd->grp_id);
+			break;
 		}
 		me = &sd->entity;
 		if (me->num_pads == 1)
@@ -322,6 +325,7 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 
 	if (!client)
 		return;
+
 	v4l2_device_unregister_subdev(sd);
 
 	if (!client->dev.of_node) {
@@ -372,7 +376,11 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
 		goto mod_put;
 
 	v4l2_set_subdev_hostdata(sd, si);
-	sd->grp_id = GRP_ID_SENSOR;
+	if (si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+		sd->grp_id = GRP_ID_FIMC_IS_SENSOR;
+	else
+		sd->grp_id = GRP_ID_SENSOR;
+
 	si->subdev = sd;
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
 		  sd->name, fmd->num_sensors);
@@ -650,6 +658,22 @@ static int register_csis_entity(struct fimc_md *fmd,
 	return ret;
 }
 
+static int register_fimc_is_entity(struct fimc_md *fmd, struct fimc_is *is)
+{
+	struct v4l2_subdev *sd = &is->isp.subdev;
+	int ret;
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (ret) {
+		v4l2_err(&fmd->v4l2_dev,
+			 "Failed to register FIMC-ISP (%d)\n", ret);
+		return ret;
+	}
+
+	fmd->fimc_is = is;
+	return 0;
+}
+
 static int fimc_md_register_platform_entity(struct fimc_md *fmd,
 					    struct platform_device *pdev,
 					    int plat_entity)
@@ -677,6 +701,9 @@ static int fimc_md_register_platform_entity(struct fimc_md *fmd,
 		case IDX_CSIS:
 			ret = register_csis_entity(fmd, pdev, drvdata);
 			break;
+		case IDX_IS_ISP:
+			ret = register_fimc_is_entity(fmd, drvdata);
+			break;
 		default:
 			ret = -ENODEV;
 		}
@@ -740,6 +767,8 @@ static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
 		/* If driver of any entity isn't ready try all again later. */
 		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
 			plat_entity = IDX_CSIS;
+		else if	(!strcmp(node->name, FIMC_IS_OF_NODE_NAME))
+			plat_entity = IDX_IS_ISP;
 		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
 			plat_entity = IDX_FLITE;
 		else if	(!strcmp(node->name, FIMC_OF_NODE_NAME) &&
@@ -1306,6 +1335,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev->notify = fimc_sensor_notify;
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
+	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
+
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 1d5cea5..0b14cd5 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
 #include <media/media-device.h>
 #include <media/media-entity.h>
@@ -80,6 +81,7 @@ struct fimc_sensor_info {
  * @num_sensors: actual number of registered sensors
  * @camclk: external sensor clock information
  * @fimc: array of registered fimc devices
+ * @fimc_is: fimc-is data structure
  * @use_isp: set to true when FIMC-IS subsystem is used
  * @pmf: handle to the CAMCLK clock control FIMC helper device
  * @media_dev: top level media device
@@ -99,6 +101,7 @@ struct fimc_md {
 	struct clk *wbclk[FIMC_MAX_WBCLKS];
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
 	struct fimc_dev *fimc[FIMC_MAX_DEVS];
+	struct fimc_is *fimc_is;
 	bool use_isp;
 	struct device *pmf;
 	struct media_device media_dev;
@@ -139,4 +142,14 @@ static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
 
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
 
+#ifdef CONFIG_OF
+static inline bool fimc_md_is_isp_available(struct device_node *node)
+{
+	node = of_get_child_by_name(node, FIMC_IS_OF_NODE_NAME);
+	return node ? of_device_is_available(node) : false;
+}
+#else
+#define fimc_md_is_isp_available(node) (false)
+#endif /* CONFIG_OF */
+
 #endif
-- 
1.7.9.5

