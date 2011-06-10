Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58899 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab1FJShL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 10 Jun 2011 20:36:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 08/19] s5p-fimc: Add the media device driver
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-9-git-send-email-s.nawrocki@samsung.com>
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The fimc media device driver is hooked onto "s5p-fimc-md" platform device.
Such a platform device need to be adde in a board initialization code
and then camera sensors need to be specified as it's platform data.
The "s5p-fimc_md" device is a top level entity for all FIMC, mipi-csis
and sensor devices.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |   12 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |   10 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  710 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h |  126 +++++
 include/media/s5p_fimc.h                    |    2 +
 7 files changed, 857 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6b2b0dc..8ec1346 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -961,7 +961,7 @@ config VIDEO_MX2
 
 config  VIDEO_SAMSUNG_S5P_FIMC
 	tristate "Samsung S5P and EXYNOS4 camera host interface driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P && MEDIA_CONTROLLER
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/video/s5p-fimc/Makefile
index df6954a..33dec7f 100644
--- a/drivers/media/video/s5p-fimc/Makefile
+++ b/drivers/media/video/s5p-fimc/Makefile
@@ -1,4 +1,4 @@
-s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-capture.o
+s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-capture.o fimc-mdevice.o
 s5p-csis-objs := mipi-csis.o
 
 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)	+= s5p-csis.o
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 00e92a0..b4387d7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -29,6 +29,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
+#include "fimc-mdevice.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
 	"sclk_fimc", "fimc"
@@ -1972,7 +1973,7 @@ static struct platform_driver fimc_driver = {
 	.remove	= __devexit_p(fimc_remove),
 	.id_table	= fimc_driver_ids,
 	.driver = {
-		.name	= MODULE_NAME,
+		.name	= FIMC_MODULE_NAME,
 		.owner	= THIS_MODULE,
 		.pm     = &fimc_pm_ops,
 	}
@@ -1980,15 +1981,18 @@ static struct platform_driver fimc_driver = {
 
 static int __init fimc_init(void)
 {
-	int ret = platform_driver_register(&fimc_driver);
+	int ret;
+
+	ret = platform_driver_register(&fimc_driver);
 	if (ret)
-		err("platform_driver_register failed: %d\n", ret);
-	return ret;
+		return ret;
+	return fimc_md_register_driver();
 }
 
 static void __exit fimc_exit(void)
 {
 	platform_driver_unregister(&fimc_driver);
+	fimc_md_unregister_driver();
 }
 
 module_init(fimc_init);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index fe82bf7..23aaa8c 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -36,7 +36,7 @@
 /* Time to wait for next frame VSYNC interrupt while stopping operation. */
 #define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
 #define MAX_FIMC_CLOCKS		2
-#define MODULE_NAME		"s5p-fimc"
+#define FIMC_MODULE_NAME	"s5p-fimc"
 #define FIMC_MAX_DEVS		4
 #define FIMC_MAX_OUT_BUFS	4
 #define SCALER_MAX_HRATIO	64
@@ -387,6 +387,12 @@ struct samsung_fimc_driverdata {
 	int		num_entities;
 };
 
+struct fimc_pipeline {
+	struct media_pipeline *pipe;
+	struct v4l2_subdev *sensor;
+	struct v4l2_subdev *csis;
+};
+
 struct fimc_ctx;
 
 /**
@@ -408,6 +414,7 @@ struct fimc_ctx;
  * @vid_cap:	camera capture device information
  * @state:	flags used to synchronize m2m and capture mode operation
  * @alloc_ctx:	videobuf2 memory allocator context
+ * @pipeline:	fimc pipeline information
  */
 struct fimc_dev {
 	spinlock_t			slock;
@@ -427,6 +434,7 @@ struct fimc_dev {
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
+	struct fimc_pipeline		pipeline;
 };
 
 /**
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
new file mode 100644
index 0000000..ae70a42
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -0,0 +1,710 @@
+/*
+ * S5P/EXYNOS4 SoC series camera host interface media device driver
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <media/media-device.h>
+
+#include "fimc-core.h"
+#include "fimc-mdevice.h"
+#include "mipi-csis.h"
+
+static int __fimc_md_configure_cam_clock(struct fimc_md *fmd,
+					 struct fimc_sensor_info *s_info,
+					 bool on);
+/**
+ * fimc_pipeline_prepare - update pipeline information with subdevice pointers
+ * @fimc: FIMC device instance that ends the pipeline
+ *
+ * Caller holds the graph mutex.
+ */
+void fimc_pipeline_prepare(struct fimc_dev *fimc, struct media_entity *me)
+{
+	struct media_entity_graph graph;
+	struct v4l2_subdev *sd;
+
+	media_entity_graph_walk_start(&graph, me);
+
+	while ((me = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(me) == MEDIA_ENT_T_DEVNODE)
+			continue;
+		sd = media_entity_to_v4l2_subdev(me);
+
+		if (me_subtype(me) == MEDIA_ENT_T_V4L2_SUBDEV_SENSOR) {
+			fimc->pipeline.sensor = sd;
+			continue;
+		}
+		if (sd->grp_id == CSIS_GROUP_ID)
+			fimc->pipeline.csis = sd;
+	}
+}
+
+/**
+ * __subdev_set_power - change power state of a single subdev
+ * @sd: subdevice to change power state for
+ * @on: 1 to enable power or 0 to disable
+ *
+ * Return result of s_power subdev operation or -ENXIO if sd argument
+ * is NULL. Return 0 if the subdevice does not implement s_power.
+ */
+static int __subdev_set_power(struct v4l2_subdev *sd, int on)
+{
+	int *use_count;
+	int ret;
+
+	if (sd == NULL)
+		return -ENXIO;
+
+	use_count = &sd->entity.use_count;
+	if (on && (*use_count)++ > 0)
+		return 0;
+	else if (!on && (*use_count == 0 || --(*use_count) > 0))
+		return 0;
+	ret = v4l2_subdev_call(sd, core, s_power, on);
+
+	return ret != -ENOIOCTLCMD ? ret : 0;
+}
+
+/**
+ * fimc_pipeline_s_power - change power state of all pipeline subdevs
+ * @fimc: FIMC device instance that ends the pipeline
+ * @state: 1 to enable power or 0 to disable
+ *
+ * Need to be called with the graph mutex held.
+ */
+int fimc_pipeline_s_power(struct fimc_dev *fimc, int state)
+{
+	int ret = 0;
+
+	if (fimc->pipeline.sensor == NULL)
+		return -ENXIO;
+
+	if (state) {
+		ret = __subdev_set_power(fimc->pipeline.csis, 1);
+		if (ret && ret != -ENXIO)
+			return ret;
+		return __subdev_set_power(fimc->pipeline.sensor, 1);
+	}
+
+	ret = __subdev_set_power(fimc->pipeline.sensor, 0);
+	if (ret)
+		return ret;
+	ret = __subdev_set_power(fimc->pipeline.csis, 0);
+
+	return ret == -ENXIO ? 0 : ret;
+}
+
+/**
+ * __fimc_pipeline_initialize - update the pipeline information, enable power
+ *                        of all pipeline subdevs and the sensor clock
+ * @me:
+ * @prep:
+ *
+ * This function must be called with the graph mutex held.
+ */
+static int __fimc_pipeline_initialize(struct fimc_dev *fimc,
+				      struct media_entity *me, bool prep)
+{
+	int ret;
+
+	if (prep)
+		fimc_pipeline_prepare(fimc, me);
+	if (fimc->pipeline.sensor == NULL)
+		return -EINVAL;
+	ret = fimc_md_configure_cam_clock(fimc->pipeline.sensor, true);
+	if (ret)
+		return ret;
+	return fimc_pipeline_s_power(fimc, 1);
+}
+
+int fimc_pipeline_initialize(struct fimc_dev *fimc, struct media_entity *me,
+			     bool prep)
+{
+	int ret;
+
+	mutex_lock(&me->parent->graph_mutex);
+	ret =  __fimc_pipeline_initialize(fimc, me, prep);
+	mutex_unlock(&me->parent->graph_mutex);
+
+	return ret;
+}
+
+/**
+ * __fimc_pipeline_shutdown - disable the sensor clock and pipeline power
+ * @fimc: fimc device that ends the pipeline
+ *
+ * Disable power of all subdevs in the pipeline and turn off the external
+ * sensor clock.
+ * Called with the graph mutex held.
+ */
+int __fimc_pipeline_shutdown(struct fimc_dev *fimc)
+{
+	int ret = 0;
+
+	if (fimc->pipeline.sensor) {
+		ret = fimc_pipeline_s_power(fimc, 0);
+		fimc_md_configure_cam_clock(fimc->pipeline.sensor, false);
+	}
+	return ret == -ENXIO ? 0 : ret;
+}
+
+int fimc_pipeline_shutdown(struct fimc_dev *fimc)
+{
+	struct media_entity *me = &fimc->vid_cap.vfd->entity;
+	int ret;
+
+	mutex_lock(&me->parent->graph_mutex);
+	ret = __fimc_pipeline_shutdown(fimc);
+	mutex_unlock(&me->parent->graph_mutex);
+
+	return ret;
+}
+
+/**
+ * fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
+ * @fimc: fimc device terminating the pipeline
+ * @on: passed as the s_stream call argument
+ */
+int fimc_pipeline_s_stream(struct fimc_dev *fimc, int on)
+{
+	struct fimc_pipeline *p = &fimc->pipeline;
+	int ret = 0;
+
+	if (p->sensor == NULL)
+		return -ENODEV;
+
+	if ((on && p->csis) || !on)
+		ret = v4l2_subdev_call(on ? p->csis : p->sensor,
+				       video, s_stream, on);
+	if (ret && ret != -ENOIOCTLCMD)
+		return ret;
+	if ((!on && p->csis) || on)
+		ret = v4l2_subdev_call(on ? p->sensor : p->csis,
+				       video, s_stream, on);
+	return ret == -ENOIOCTLCMD ? 0 : ret;
+}
+
+/*
+ * Sensor subdevice helper functions
+ */
+static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
+				   struct fimc_sensor_info *s_info)
+{
+	struct i2c_adapter *adapter;
+	struct v4l2_subdev *sd = NULL;
+
+	if (!s_info || !fmd)
+		return NULL;
+
+	adapter = i2c_get_adapter(s_info->pdata->i2c_bus_num);
+	if (!adapter)
+		return ERR_PTR(-ENOMEM);
+	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
+				       s_info->pdata->board_info, NULL);
+	if (!sd) {
+		v4l2_err(&fmd->v4l2_dev, "Failed to acquire subdev\n");
+		return NULL;
+	}
+	v4l2_set_subdev_hostdata(sd, s_info);
+	sd->grp_id = SENSOR_GROUP_ID;
+
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
+		  s_info->pdata->board_info->type);
+	return sd;
+}
+
+static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!client)
+		return;
+	v4l2_device_unregister_subdev(sd);
+	i2c_unregister_device(client);
+	i2c_put_adapter(client->adapter);
+}
+
+static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
+{
+	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
+	int i = min(pdata->num_clients, FIMC_MAX_SENSORS);
+	int ret;
+
+	WARN(pdata->num_clients > FIMC_MAX_SENSORS,
+	     "Excessive number of sensors specified: %d\n", pdata->num_clients);
+
+	fmd->num_sensors = i;
+	while (--i >= 0) {
+		fmd->sensor[i].pdata = &pdata->isp_info[i];
+		ret = __fimc_md_configure_cam_clock(fmd, &fmd->sensor[i], true);
+		if (ret)
+			break;
+		fmd->sensor[i].subdev =
+			fimc_md_register_sensor(fmd, &fmd->sensor[i]);
+		ret = __fimc_md_configure_cam_clock(fmd, &fmd->sensor[i], false);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+/*
+ * MIPI CSIS and FIMC platform devices registration.
+ */
+static int fimc_register_callback(struct device *dev, void *p)
+{
+	struct fimc_dev *fimc = dev_get_drvdata(dev);
+	struct fimc_md *fmd = p;
+	int ret;
+
+	if (!fimc || !fimc->pdev)
+		return 0;
+	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
+		return 0;
+
+	fmd->fimc[fimc->pdev->id] = fimc;
+	ret = fimc_register_m2m_device(fimc, &fmd->v4l2_dev);
+	if (ret)
+		return ret;
+	return fimc_register_capture_device(fimc, &fmd->v4l2_dev);
+}
+
+static int csis_register_callback(struct device *dev, void *p)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct fimc_md *fmd = p;
+	struct platform_device *pdev;
+	int ret;
+
+	if (!sd)
+		return 0;
+	pdev = v4l2_get_subdevdata(sd);
+	if (!pdev || pdev->id < 0 || pdev->id >= CSIS_MAX_ENTITIES)
+		return 0;
+	v4l2_info(sd, "csis%d sd: %s\n", pdev->id, sd->name);
+
+	fmd->csis[pdev->id].sd = sd;
+	sd->grp_id = CSIS_GROUP_ID;
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (ret)
+		v4l2_err(&fmd->v4l2_dev,
+			 "Failed to register CSIS subdevice: %d\n", ret);
+	return ret;
+}
+
+/**
+ * fimc_md_register_platform_entities - register FIMC and CSIS media entities
+ */
+static int fimc_md_register_platform_entities(struct fimc_md *fmd)
+{
+	struct device_driver *driver;
+	int ret;
+
+	driver = driver_find(FIMC_MODULE_NAME, &platform_bus_type);
+	if (!driver)
+		return -ENODEV;
+	ret = driver_for_each_device(driver, NULL, fmd,
+				     fimc_register_callback);
+	put_driver(driver);
+	if (ret)
+		return ret;
+
+	driver = driver_find(CSIS_DRIVER_NAME, &platform_bus_type);
+	if (driver) {
+		ret = driver_for_each_device(driver, NULL, fmd,
+					     csis_register_callback);
+		put_driver(driver);
+	}
+	return ret;
+}
+
+static void fimc_md_unregister_entities(struct fimc_md *fmd)
+{
+	int i;
+
+	if (fmd == NULL)
+		return;
+
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		fimc_unregister_m2m_device(fmd->fimc[i]);
+		fimc_unregister_capture_device(fmd->fimc[i]);
+	}
+	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
+		if (fmd->csis[i].sd == NULL)
+			continue;
+		v4l2_device_unregister_subdev(fmd->csis[i].sd);
+		fmd->csis[i].sd = NULL;
+	}
+	for (i = 0; i < fmd->num_sensors; i++) {
+		if (fmd->sensor[i].subdev == NULL)
+			continue;
+		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
+		fmd->sensor[i].subdev = NULL;
+	}
+}
+
+/**
+ * __fimc_md_create_fimc_links - create links to all FIMC entities
+ * @fmd: fimc media device
+ * @source: the source entity to create links to all fimc entities from
+ * @sensor: sensor subdev linked to fimc (fimc_id) entity
+ * @pad: the source entity pad
+ * @fimc_id: index of the fimc device for which link should be enabled
+ */
+static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
+				       struct media_entity *source,
+				       struct v4l2_subdev *sensor,
+				       int pad, int fimc_id)
+{
+	struct fimc_sensor_info *s_info;
+	struct media_entity *sink;
+	unsigned int flags;
+	int rc, i;
+
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		if (fmd->fimc[i] == NULL)
+			break;
+		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
+		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
+		rc = media_entity_create_link(source, 0, sink, 0, flags);
+		if (rc)
+			return rc;
+
+		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]",
+			  source->name, flags ? '=' : '-', sink->name);
+
+		if (flags == 0)
+			continue;
+		s_info = v4l2_get_subdev_hostdata(sensor);
+		if (!WARN_ON(s_info == NULL)) {
+			unsigned long irq_flags;
+			spin_lock_irqsave(&fmd->slock, irq_flags);
+			s_info->parent = fmd->fimc[i];
+			spin_unlock_irqrestore(&fmd->slock, irq_flags);
+		}
+	}
+	return 0;
+}
+
+/**
+ * fimc_md_create_links - create default links between registered entities
+ *
+ * Parallel interface sensor entities are connected directly to FIMC capture
+ * entities. The sensors using MIPI CSIS bus are connected through immutable
+ * link with CSI receiver entity specified by mux_id. Any registered CSIS
+ * entity has a link to each registered FIMC capture entity. Enabled links
+ * are created by default between each subsequent registered sensor and
+ * subsequent FIMC capture entity. The number of default active links is
+ * determined by the number of available sensors or FIMC entities,
+ * whichever is less.
+ */
+static int fimc_md_create_links(struct fimc_md *fmd)
+{
+	struct v4l2_subdev *sensor, *csis;
+	struct s5p_fimc_isp_info *pdata;
+	struct fimc_sensor_info *s_info;
+	struct media_entity *source;
+	int fimc_id = 0;
+	int i, pad;
+	int rc = 0;
+
+	for (i = 0; i < fmd->num_sensors; i++) {
+		if (fmd->sensor[i].subdev == NULL)
+			continue;
+
+		sensor = fmd->sensor[i].subdev;
+		s_info = v4l2_get_subdev_hostdata(sensor);
+		if (!s_info || !s_info->pdata)
+			continue;
+
+		source = NULL;
+		pdata = s_info->pdata;
+
+		switch (pdata->bus_type) {
+		case FIMC_MIPI_CSI2:
+			if (WARN(pdata->mux_id >= CSIS_MAX_ENTITIES,
+				"Wrong CSI channel id: %d\n", pdata->mux_id))
+				return -EINVAL;
+
+			csis = fmd->csis[pdata->mux_id].sd;
+			if (WARN(csis == NULL,
+				 "MIPI-CSI interface specified "
+				 "but s5p-csis module is not loaded!\n"))
+				continue;
+
+			rc = media_entity_create_link(&sensor->entity, 0,
+					      &csis->entity, CSIS_PAD_SINK,
+					      MEDIA_LNK_FL_IMMUTABLE |
+					      MEDIA_LNK_FL_ENABLED);
+			if (rc)
+				return rc;
+
+			v4l2_info(&fmd->v4l2_dev, "created link [%s] => [%s]",
+				  sensor->entity.name, csis->entity.name);
+
+			source = &csis->entity;
+			pad = CSIS_PAD_SOURCE;
+			break;
+
+		case FIMC_ITU_601...FIMC_ITU_656:
+			source = &sensor->entity;
+			pad = 0;
+			break;
+
+		default:
+			v4l2_err(&fmd->v4l2_dev, "Wrong bus_type: %x\n",
+				 pdata->bus_type);
+			return -EINVAL;
+		}
+		if (source == NULL)
+			continue;
+
+		rc = __fimc_md_create_fimc_links(fmd, source, sensor, pad,
+						 fimc_id++);
+	}
+	return rc;
+}
+
+/*
+ * The peripheral sensor clock management.
+ */
+static int fimc_md_get_clocks(struct fimc_md *fmd)
+{
+	int i = FIMC_MAX_CAMCLKS;
+	char clk_name[32];
+
+	while (--i >= 0) {
+		snprintf(clk_name, sizeof(clk_name), "sclk_cam.%u", i);
+		fmd->camclk[i].clock = clk_get(NULL, clk_name);
+
+		if (IS_ERR_OR_NULL(fmd->camclk[i].clock)) {
+			v4l2_err(&fmd->v4l2_dev, "Failed to get clock: %s",
+				  clk_name);
+			return -ENXIO;
+		}
+		v4l2_info(&fmd->v4l2_dev, "Acquired clock: %s", clk_name);
+	}
+	return 0;
+}
+
+static void fimc_md_put_clocks(struct fimc_md *fmd)
+{
+	int i = FIMC_MAX_CAMCLKS;
+
+	while (--i >= 0) {
+		if (IS_ERR_OR_NULL(fmd->camclk[i].clock))
+			continue;
+		clk_put(fmd->camclk[i].clock);
+	}
+}
+
+static int __fimc_md_configure_cam_clock(struct fimc_md *fmd,
+					 struct fimc_sensor_info *s_info,
+					 bool on)
+{
+	struct s5p_fimc_isp_info *pdata = s_info->pdata;
+	struct fimc_camclk_info *camclk;
+	int ret = 0;
+
+	if (WARN_ON(pdata->clk_id >= FIMC_MAX_CAMCLKS) || fmd == NULL)
+		return -EINVAL;
+
+	if (s_info->clk_on == on)
+		return 0;
+	camclk = &fmd->camclk[pdata->clk_id];
+
+	dbg("camclk %d, f: %lu, clk: %p, on: %d",
+	    pdata->clk_id, pdata->clk_frequency, camclk, on);
+
+	if (on) {
+		if (camclk->use_count > 0 &&
+		    camclk->frequency != pdata->clk_frequency)
+			return -EINVAL;
+
+		if (camclk->use_count++ == 0) {
+			clk_set_rate(camclk->clock, pdata->clk_frequency);
+			camclk->frequency = pdata->clk_frequency;
+			ret = clk_enable(camclk->clock);
+		}
+		s_info->clk_on = 1;
+		dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
+		    clk_get_rate(camclk->clock));
+
+		return ret;
+	}
+
+	if (WARN_ON(camclk->use_count == 0))
+		return 0;
+
+	if (--camclk->use_count == 0) {
+		clk_disable(camclk->clock);
+		s_info->clk_on = 0;
+		dbg("Disabled camclk %d", pdata->clk_id);
+	}
+	return ret;
+}
+
+/**
+ * fimc_md_configure_cam_clock - peripheral sensor clock configuration
+ * @sd: sensor subdev to configure sclk_cam clock for
+ * @on: 1 to enable or 0 to disable the clock
+ *
+ * There are 2 separate clock outputs available in the SoC for external
+ * image processors. These clocks are shared between all registered FIMC
+ * devices to which sensors can be attached, either directly or through
+ * the MIPI CSI receiver. The clock is allowed here to be used by
+ * multiple sensors concurrently if they use same frequency.
+ * The per sensor subdev clk_on attribute helps to synchronize accesses
+ * to the sclk_cam clocks from the video and media device nodes.
+ * This function should only be called when the graph mutex is held.
+ */
+int fimc_md_configure_cam_clock(struct v4l2_subdev *sd, bool on)
+{
+	struct fimc_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
+
+	return __fimc_md_configure_cam_clock(fmd, s_info, on);
+}
+
+static int fimc_md_link_notify(struct media_pad *source,
+			       struct media_pad *sink, u32 flags)
+{
+	struct video_device *vid_dev;
+	struct fimc_dev *fimc;
+	int ret = 0;
+
+	if (WARN_ON(media_entity_type(sink->entity) != MEDIA_ENT_T_DEVNODE))
+		return 0;
+
+	vid_dev = media_entity_to_video_device(sink->entity);
+	fimc = video_get_drvdata(vid_dev);
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		ret = __fimc_pipeline_shutdown(fimc);
+		fimc->pipeline.sensor = NULL;
+		fimc->pipeline.csis = NULL;
+		return ret;
+	}
+	/*
+	 * Link activation. Enable power of pipeline elements only if the
+	 * pipeline is already in use, i.e. its video node is opened.
+	 */
+	mutex_lock(&fimc->lock);
+	if (fimc->vid_cap.refcnt > 0)
+		ret = __fimc_pipeline_initialize(fimc, source->entity, true);
+	mutex_unlock(&fimc->lock);
+
+	return ret ? -EPIPE : ret;
+}
+
+static int __devinit fimc_md_probe(struct platform_device *pdev)
+{
+	struct v4l2_device *v4l2_dev;
+	struct fimc_md *fmd;
+	int rc;
+
+	if (WARN(!pdev->dev.platform_data, "Platform data not specified!\n"))
+		return -ENOMEM;
+
+	fmd = kzalloc(sizeof(struct fimc_md), GFP_KERNEL);
+	if (!fmd)
+		return -ENOMEM;
+
+	spin_lock_init(&fmd->slock);
+	fmd->pdev = pdev;
+
+	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
+		sizeof(fmd->media_dev.model));
+	fmd->media_dev.link_notify = fimc_md_link_notify;
+	fmd->media_dev.dev = &pdev->dev;
+
+	v4l2_dev = &fmd->v4l2_dev;
+	v4l2_dev->mdev = &fmd->media_dev;
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
+		 dev_name(&pdev->dev));
+
+	rc = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
+	if (rc < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", rc);
+		goto err1;
+	}
+
+	rc = media_device_register(&fmd->media_dev);
+	if (rc < 0) {
+		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", rc);
+		goto err2;
+	}
+
+	rc = fimc_md_get_clocks(fmd);
+	if (rc)
+		goto err3;
+	rc = fimc_md_register_platform_entities(fmd);
+	if (rc)
+		goto err3;
+	rc = fimc_md_register_sensor_entities(fmd);
+	if (rc)
+		goto err3;
+	rc = fimc_md_create_links(fmd);
+	if (rc)
+		goto err3;
+	rc = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
+	if (!rc)
+		return 0;
+err3:
+	fimc_md_put_clocks(fmd);
+	fimc_md_unregister_entities(fmd);
+err2:
+	v4l2_device_unregister(&fmd->v4l2_dev);
+err1:
+	kfree(fmd);
+	return rc;
+}
+
+static int __devexit fimc_md_remove(struct platform_device *pdev)
+{
+	struct fimc_md *fmd = pdev_to_fimc_mdev(pdev);
+
+	fimc_md_unregister_entities(fmd);
+	media_device_unregister(&fmd->media_dev);
+	fimc_md_put_clocks(fmd);
+	kfree(fmd);
+	return 0;
+}
+
+static struct platform_driver fimc_md_driver = {
+	.probe		= fimc_md_probe,
+	.remove		= __devexit_p(fimc_md_remove),
+	.driver = {
+		.name	= "s5p-fimc-md",
+		.owner	= THIS_MODULE,
+	}
+};
+
+int __init fimc_md_register_driver(void)
+{
+	request_module("s5p-csis");
+	return platform_driver_register(&fimc_md_driver);
+}
+
+void __exit fimc_md_unregister_driver(void)
+{
+	platform_driver_unregister(&fimc_md_driver);
+}
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
new file mode 100644
index 0000000..f5c8e6f
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_MDEVICE_H_
+#define FIMC_MDEVICE_H_
+
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#include "fimc-core.h"
+#include "mipi-csis.h"
+
+/* Group IDs of sensor, MIPI CSIS and the writeback subdevs. */
+#define SENSOR_GROUP_ID		(1 << 8)
+#define CSIS_GROUP_ID		(1 << 9)
+#define WRITEBACK_GROUP_ID	(1 << 10)
+
+#define FIMC_MAX_SENSORS	8
+#define FIMC_MAX_CAMCLKS	2
+
+struct fimc_csis_info {
+	struct v4l2_subdev *sd;
+	int id;
+};
+
+struct fimc_camclk_info {
+	struct clk *clock;
+	int use_count;
+	unsigned long frequency;
+};
+
+/**
+ * struct fimc_sensor_info - image data source subdev information
+ * @pdata: sensor's atrributes passed as media device's platform data
+ * @subdev: image sensor v4l2 subdev
+ * @parent: fimc device the sensor is currently linked to
+ * @clk_on: sclk_cam clock's state associated with this subdev
+ *
+ * This data structure applies to image sensor and the writeback subdevs.
+ */
+struct fimc_sensor_info {
+	struct s5p_fimc_isp_info *pdata;
+	struct v4l2_subdev *subdev;
+	struct fimc_dev *parent;
+	bool clk_on;
+};
+
+/**
+ * struct fimc_md - fimc media device information
+ * @csis: MIPI CSIS subdevs data
+ * @sensor: array of registered sensor subdevs
+ * @num_sensors: actual number of registered sensors
+ * @camclk: external sensor clock information
+ * @fimc: array of registered fimc devices
+ * @media_dev: top level media device
+ * @v4l2_dev: top level v4l2_device holding up the subdevs
+ * @pdev: platform device this media device is hooked up into
+ * @slock: spinlock protecting @sensor array
+ */
+struct fimc_md {
+	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
+	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
+	int num_sensors;
+	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
+	struct fimc_dev *fimc[FIMC_MAX_DEVS];
+	struct media_device media_dev;
+	struct v4l2_device v4l2_dev;
+	struct platform_device *pdev;
+	spinlock_t slock;
+};
+
+#define is_subdev_pad(pad) (pad == NULL || \
+	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
+
+#define me_subtype(me) \
+	((me->type) & (MEDIA_ENT_TYPE_MASK | MEDIA_ENT_SUBTYPE_MASK))
+
+#define subdev_has_devnode(__sd) (__sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)
+
+static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
+{
+	return me->parent == NULL ? NULL :
+		container_of(me->parent, struct fimc_md, media_dev);
+}
+
+static inline struct fimc_md *pdev_to_fimc_mdev(struct platform_device *pdev)
+{
+	struct v4l2_device *dev = pdev ? platform_get_drvdata(pdev) : NULL;
+	BUG_ON(!dev);
+	return container_of(dev, struct fimc_md, v4l2_dev);
+}
+
+static inline void fimc_md_graph_lock(struct fimc_dev *fimc)
+{
+	BUG_ON(fimc->vid_cap.vfd == NULL);
+	mutex_lock(&fimc->vid_cap.vfd->entity.parent->graph_mutex);
+}
+
+static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
+{
+	BUG_ON(fimc->vid_cap.vfd == NULL);
+	mutex_unlock(&fimc->vid_cap.vfd->entity.parent->graph_mutex);
+}
+
+int fimc_md_configure_cam_clock(struct v4l2_subdev *sd, bool on);
+void fimc_pipeline_prepare(struct fimc_dev *fimc, struct media_entity *me);
+int fimc_pipeline_initialize(struct fimc_dev *fimc, struct media_entity *me,
+			     bool resume);
+int fimc_pipeline_shutdown(struct fimc_dev *fimc);
+int fimc_pipeline_s_power(struct fimc_dev *fimc, int state);
+int fimc_pipeline_s_stream(struct fimc_dev *fimc, int state);
+
+int fimc_md_register_driver(void);
+void fimc_md_unregister_driver(void);
+
+#endif
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 9fdff8a..086a7aa 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -36,6 +36,7 @@ struct i2c_board_info;
  * @csi_data_align: MIPI-CSI interface data alignment in bits
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
+ * @clk_id: index of the SoC peripheral clock for sensors
  * @flags: flags defining bus signals polarity inversion (High by default)
  */
 struct s5p_fimc_isp_info {
@@ -46,6 +47,7 @@ struct s5p_fimc_isp_info {
 	u16 i2c_bus_num;
 	u16 mux_id;
 	u16 flags;
+	u8 clk_id;
 };
 
 /**
-- 
1.7.5.4

