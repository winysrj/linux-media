Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45912 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3CKTpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:39 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 7/8] s5p-fimc: Add fimc-is subdevs registration
Date: Mon, 11 Mar 2013 20:44:51 +0100
Message-id: <1363031092-29950-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   51 ++++++++++++++++++++++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |   15 +++++++
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index e9e5337..1521dec 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -31,6 +31,7 @@
 #include <media/s5p_fimc.h>
 
 #include "fimc-core.h"
+#include "fimc-is.h"
 #include "fimc-lite.h"
 #include "fimc-mdevice.h"
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
@@ -291,6 +294,7 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 
 	if (!client)
 		return;
+
 	v4l2_device_unregister_subdev(sd);
 
 	if (!client->dev.of_node) {
@@ -341,7 +345,11 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
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
@@ -360,7 +368,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 				   struct device_node *port,
 				   unsigned int index)
 {
-	struct device_node *rem, *endpoint;
+	struct device_node *rem, *endpoint, *np;
 	struct fimc_source_info *pd;
 	struct v4l2_of_endpoint bus_cfg;
 	u32 tmp, reg = 0;
@@ -415,6 +423,18 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
 			 reg, rem->full_name);
 	}
+	/*
+	 * For FIMC-IS handled sensors, that are placed under fimc-is-i2c
+	 * device node, FIMC is connected to the FIMC-IS through its ISP
+	 * Writeback input. Sensors are attached to the FIMC-LITE hostdata
+	 * interface directly or through MIPI-CSIS, depending on the external
+	 * media bus used. This needs to be handled in a more reliable way,
+	 * not by just checking parent's node name.
+	 */
+	if ((np = of_get_parent(rem)) && !of_node_cmp(np->name, "i2c-isp"))
+		pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
+	else
+		pd->fimc_bus_type = pd->sensor_bus_type;
 
 	ret = fimc_md_of_add_sensor(fmd, rem, index);
 	of_node_put(rem);
@@ -607,6 +627,22 @@ static int register_csis_entity(struct fimc_md *fmd,
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
@@ -634,6 +670,9 @@ static int fimc_md_register_platform_entity(struct fimc_md *fmd,
 		case IDX_CSIS:
 			ret = register_csis_entity(fmd, pdev, drvdata);
 			break;
+		case IDX_IS_ISP:
+			ret = register_fimc_is_entity(fmd, drvdata);
+			break;
 		default:
 			ret = -ENODEV;
 		}
@@ -697,6 +736,8 @@ static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
 		/* If driver of any entity isn't ready try all again later. */
 		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
 			plat_entity = IDX_CSIS;
+		else if	(!strcmp(node->name, FIMC_IS_OF_NODE_NAME))
+			plat_entity = IDX_IS_ISP;
 		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
 			plat_entity = IDX_FLITE;
 		else if	(!strcmp(node->name, FIMC_OF_NODE_NAME))
@@ -1271,6 +1312,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev->notify = fimc_sensor_notify;
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
+	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
+
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index a827bf9..52a8ecb 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
 #include <media/media-device.h>
 #include <media/media-entity.h>
@@ -81,6 +82,8 @@ struct fimc_sensor_info {
  * @camclk: external sensor clock information
  * @fimc: array of registered fimc devices
  * @pmf: handle to the CAMCLK clock control FIMC helper device
+ * @fimc_is: fimc-is data structure
+ * @use_isp: set to true when FIMC-IS subsystem is used
  * @media_dev: top level media device
  * @v4l2_dev: top level v4l2_device holding up the subdevs
  * @pdev: platform device this media device is hooked up into
@@ -99,6 +102,8 @@ struct fimc_md {
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
 	struct fimc_dev *fimc[FIMC_MAX_DEVS];
 	struct device *pmf;
+	struct fimc_is *fimc_is;
+	bool use_isp;
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
@@ -137,4 +142,14 @@ static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
 
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

