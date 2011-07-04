Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58946 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab1GDRzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 04 Jul 2011 19:54:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 08/19] s5p-fimc: Add the media device driver
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-9-git-send-email-s.nawrocki@samsung.com>
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The fimc media device driver is hooked onto "s5p-fimc-md" platform device.
Such a platform device need to be added in a board initialization code
and then camera sensors need to be specified as it's platform data.
The "s5p-fimc-md" device is a top level entity for all FIMC, mipi-csis
and sensor devices.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |   33 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |   16 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  804 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h |  118 ++++
 include/media/s5p_fimc.h                    |    2 +
 7 files changed, 956 insertions(+), 21 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 2cc9552..d5ad61b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -935,7 +935,7 @@ config VIDEO_MX2
 
 config  VIDEO_SAMSUNG_S5P_FIMC
 	tristate "Samsung S5P and EXYNOS4 camera host interface driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P && I2C && VIDEO_V4L2_SUBDEV_API
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
index 8e2f2ee..59190aa 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -28,6 +28,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
+#include "fimc-mdevice.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
 	"sclk_fimc", "fimc"
@@ -1876,6 +1877,7 @@ static struct fimc_pix_limit s5p_pix_limit[4] = {
 static struct samsung_fimc_variant fimc0_variant_s5p = {
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
@@ -1884,6 +1886,7 @@ static struct samsung_fimc_variant fimc0_variant_s5p = {
 };
 
 static struct samsung_fimc_variant fimc2_variant_s5p = {
+	.has_cam_if	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
@@ -1895,6 +1898,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
@@ -1906,6 +1910,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
 	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
@@ -1915,6 +1920,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
 };
 
 static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
+	.has_cam_if	 = 1,
 	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
@@ -1927,6 +1933,7 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
@@ -1936,8 +1943,9 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc2_variant_exynos4 = {
+static struct samsung_fimc_variant fimc3_variant_exynos4 = {
 	.pix_hoff	 = 1,
+	.has_cam_if	 = 1,
 	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
@@ -1975,7 +1983,7 @@ static struct samsung_fimc_driverdata fimc_drvdata_exynos4 = {
 		[0] = &fimc0_variant_exynos4,
 		[1] = &fimc0_variant_exynos4,
 		[2] = &fimc0_variant_exynos4,
-		[3] = &fimc2_variant_exynos4,
+		[3] = &fimc3_variant_exynos4,
 	},
 	.num_entities = 4,
 	.lclk_frequency = 166000000UL,
@@ -2003,32 +2011,21 @@ static const struct dev_pm_ops fimc_pm_ops = {
 
 static struct platform_driver fimc_driver = {
 	.probe		= fimc_probe,
-	.remove	= __devexit_p(fimc_remove),
+	.remove		= __devexit_p(fimc_remove),
 	.id_table	= fimc_driver_ids,
 	.driver = {
-		.name	= MODULE_NAME,
+		.name	= FIMC_MODULE_NAME,
 		.owner	= THIS_MODULE,
 		.pm     = &fimc_pm_ops,
 	}
 };
 
-static int __init fimc_init(void)
+int __init fimc_register_driver(void)
 {
-	int ret = platform_driver_register(&fimc_driver);
-	if (ret)
-		err("platform_driver_register failed: %d\n", ret);
-	return ret;
+	return platform_driver_probe(&fimc_driver, fimc_probe);
 }
 
-static void __exit fimc_exit(void)
+void __exit fimc_unregister_driver(void)
 {
 	platform_driver_unregister(&fimc_driver);
 }
-
-module_init(fimc_init);
-module_exit(fimc_exit);
-
-MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
-MODULE_DESCRIPTION("S5P FIMC camera host interface/video postprocessor driver");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0.1");
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index fe82bf7..25a8005 100644
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
@@ -308,6 +308,7 @@ struct fimc_m2m_device {
  * @reqbufs_count: the number of buffers requested in REQBUFS ioctl
  * @input_index: input (camera sensor) index
  * @refcnt: driver's private reference counter
+ * @vid_dev_compat: true to enable full pipeline setup in the driver
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
@@ -325,6 +326,7 @@ struct fimc_vid_cap {
 	unsigned int			reqbufs_count;
 	int				input_index;
 	int				refcnt;
+	bool				vid_dev_compat;
 };
 
 /**
@@ -355,6 +357,7 @@ struct fimc_pix_limit {
  * @has_cistatus2: 1 if CISTATUS2 register is present in this IP revision
  * @has_mainscaler_ext: 1 if extended mainscaler ratios in CIEXTEN register
  *			 are present in this IP revision
+ * @has_cam_if: set if this instance has a camera input interface
  * @pix_limit: pixel size constraints for the scaler
  * @min_inp_pixsize: minimum input pixel size
  * @min_out_pixsize: minimum output pixel size
@@ -367,6 +370,7 @@ struct samsung_fimc_variant {
 	unsigned int	has_out_rot:1;
 	unsigned int	has_cistatus2:1;
 	unsigned int	has_mainscaler_ext:1;
+	unsigned int	has_cam_if:1;
 	struct fimc_pix_limit *pix_limit;
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
@@ -387,6 +391,12 @@ struct samsung_fimc_driverdata {
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
@@ -408,6 +418,7 @@ struct fimc_ctx;
  * @vid_cap:	camera capture device information
  * @state:	flags used to synchronize m2m and capture mode operation
  * @alloc_ctx:	videobuf2 memory allocator context
+ * @pipeline:	fimc video capture pipeline data structure
  */
 struct fimc_dev {
 	spinlock_t			slock;
@@ -427,6 +438,7 @@ struct fimc_dev {
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
+	struct fimc_pipeline		pipeline;
 };
 
 /**
@@ -645,6 +657,8 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev);
 void fimc_unregister_m2m_device(struct fimc_dev *fimc);
+int fimc_register_driver(void);
+void fimc_unregister_driver(void);
 
 /* -----------------------------------------------------*/
 /* fimc-capture.c					*/
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
new file mode 100644
index 0000000..10c8d5d
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -0,0 +1,804 @@
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
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <media/media-device.h>
+
+#include "fimc-core.h"
+#include "fimc-mdevice.h"
+#include "mipi-csis.h"
+
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
+				struct fimc_sensor_info *s_info,
+				bool on);
+/**
+ * fimc_pipeline_prepare - update pipeline information with subdevice pointers
+ * @fimc: fimc device terminating the pipeline
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
+		if (media_entity_type(me) != MEDIA_ENT_T_V4L2_SUBDEV)
+			continue;
+		sd = media_entity_to_v4l2_subdev(me);
+
+		if (sd->grp_id == SENSOR_GROUP_ID)
+			fimc->pipeline.sensor = sd;
+		else if (sd->grp_id == CSIS_GROUP_ID)
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
+ * @fimc: fimc device terminating the pipeline
+ * @state: 1 to enable power or 0 for power down
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
+ *                              of all pipeline subdevs and the sensor clock
+ * @me: media entity to start graph walk with
+ * @prep: true to acquire sensor (and csis) subdevs
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
+	ret = fimc_md_set_camclk(fimc->pipeline.sensor, true);
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
+ * @fimc: fimc device terminating the pipeline
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
+		fimc_md_set_camclk(fimc->pipeline.sensor, false);
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
+		return NULL;
+	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
+				       s_info->pdata->board_info, NULL);
+	if (IS_ERR_OR_NULL(sd)) {
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
+	struct fimc_dev *fd = NULL;
+	int num_clients, ret, i;
+
+	/*
+	 * Runtime resume one of the FIMC entities to make sure
+	 * the sclk_cam clocks are not globally disabled.
+	 */
+	for (i = 0; !fd && i < ARRAY_SIZE(fmd->fimc); i++)
+		if (fmd->fimc[i])
+			fd = fmd->fimc[i];
+	if (!fd)
+		return -ENXIO;
+	ret = pm_runtime_get_sync(&fd->pdev->dev);
+	if (ret < 0)
+		return ret;
+
+	WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
+	num_clients = min_t(u32, pdata->num_clients, ARRAY_SIZE(fmd->sensor));
+
+	fmd->num_sensors = num_clients;
+	for (i = 0; i < num_clients; i++) {
+		fmd->sensor[i].pdata = &pdata->isp_info[i];
+		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
+		if (ret)
+			break;
+		fmd->sensor[i].subdev =
+			fimc_md_register_sensor(fmd, &fmd->sensor[i]);
+		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
+		if (ret)
+			break;
+	}
+	pm_runtime_put(&fd->pdev->dev);
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
+	if (ret || !fimc->variant->has_cam_if)
+		return ret;
+	ret = fimc_register_capture_device(fimc, &fmd->v4l2_dev);
+	if (!ret)
+		fimc->vid_cap.vid_dev_compat = fmd->vid_dev_compat;
+	return ret;
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
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		if (fmd->fimc[i] == NULL)
+			continue;
+		fimc_unregister_m2m_device(fmd->fimc[i]);
+		fimc_unregister_capture_device(fmd->fimc[i]);
+		fmd->fimc[i] = NULL;
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
+	int ret, i;
+
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		if (!fmd->fimc[i])
+			break;
+		/*
+		 * Some FIMC variants are not fitted with camera capture
+		 * interface. Skip creating a link from sensor for those.
+		 */
+		if (sensor->grp_id == SENSOR_GROUP_ID &&
+		    !fmd->fimc[i]->variant->has_cam_if)
+			continue;
+
+		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
+		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
+		ret = media_entity_create_link(source, 0, sink, 0, flags);
+		if (ret)
+			return ret;
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
+			s_info->host = fmd->fimc[i];
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
+	int ret = 0;
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
+			ret = media_entity_create_link(&sensor->entity, 0,
+					      &csis->entity, CSIS_PAD_SINK,
+					      MEDIA_LNK_FL_IMMUTABLE |
+					      MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
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
+		ret = __fimc_md_create_fimc_links(fmd, source, sensor, pad,
+						 fimc_id++);
+	}
+	return ret;
+}
+
+/*
+ * The peripheral sensor clock management.
+ */
+static int fimc_md_get_clocks(struct fimc_md *fmd)
+{
+	char clk_name[32];
+	struct clk *clock;
+	int i;
+
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
+		snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
+		clock = clk_get(NULL, clk_name);
+		if (IS_ERR_OR_NULL(clock)) {
+			v4l2_err(&fmd->v4l2_dev, "Failed to get clock: %s",
+				  clk_name);
+			return -ENXIO;
+		}
+		fmd->camclk[i].clock = clock;
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
+		fmd->camclk[i].clock = NULL;
+	}
+}
+
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
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
+ * fimc_md_set_camclk - peripheral sensor clock setup
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
+int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
+{
+	struct fimc_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
+
+	return __fimc_md_set_camclk(fmd, s_info, on);
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
+static ssize_t fimc_md_sysfs_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+
+	if (fmd->vid_dev_compat)
+		return strlcpy(buf, "V4L2 video node only API (vid-dev)\n",
+			       PAGE_SIZE);
+
+	return strlcpy(buf, "Sub-device API (sub-dev)\n",
+		       PAGE_SIZE);
+}
+
+static ssize_t fimc_md_sysfs_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+	int vdev_compat;
+	int i;
+
+	if (!strcmp(buf, "vid-dev\n"))
+		vdev_compat = 1;
+	else if (!strcmp(buf, "sub-dev\n"))
+		vdev_compat = 0;
+	else
+		return count;
+
+	fmd->vid_dev_compat = vdev_compat;
+	for (i = 0; i < FIMC_MAX_DEVS; i++)
+		if (fmd->fimc[i])
+			fmd->fimc[i]->vid_cap.vid_dev_compat = vdev_compat;
+	return count;
+}
+/*
+ * This device attribute is to select video pipeline configuration method.
+ * There are following valid values:
+ *  vid-dev - for V4L2 video node API only, subdevice will be configured
+ *  by the host driver.
+ *  sub-dev - for media controller API, subdevs must be configured in user
+ *  space before starting streaming.
+ */
+static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
+		   fimc_md_sysfs_show, fimc_md_sysfs_store);
+
+static int __devinit fimc_md_probe(struct platform_device *pdev)
+{
+	struct v4l2_device *v4l2_dev;
+	struct fimc_md *fmd;
+	int ret;
+
+	if (WARN(!pdev->dev.platform_data, "Platform data not specified!\n"))
+		return -EINVAL;
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
+	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
+		goto err1;
+	}
+	ret = media_device_register(&fmd->media_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
+		goto err2;
+	}
+	ret = fimc_md_get_clocks(fmd);
+	if (ret)
+		goto err3;
+
+	fmd->vid_dev_compat = 1;
+	ret = fimc_md_register_platform_entities(fmd);
+	if (ret)
+		goto err3;
+
+	ret = fimc_md_register_sensor_entities(fmd);
+	if (ret)
+		goto err3;
+	ret = fimc_md_create_links(fmd);
+	if (ret)
+		goto err3;
+	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
+	if (ret)
+		goto err3;
+	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
+	if (!ret) {
+		platform_set_drvdata(pdev, fmd);
+		return 0;
+	}
+err3:
+	media_device_unregister(&fmd->media_dev);
+	fimc_md_put_clocks(fmd);
+	fimc_md_unregister_entities(fmd);
+err2:
+	v4l2_device_unregister(&fmd->v4l2_dev);
+err1:
+	kfree(fmd);
+	return ret;
+}
+
+static int __devexit fimc_md_remove(struct platform_device *pdev)
+{
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+
+	if (!fmd)
+		return 0;
+	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
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
+int __init fimc_md_init(void)
+{
+	int ret;
+	request_module("s5p-csis");
+	ret = fimc_register_driver();
+	if (ret)
+		return ret;
+	return platform_driver_register(&fimc_md_driver);
+}
+void __exit fimc_md_exit(void)
+{
+	platform_driver_unregister(&fimc_md_driver);
+	fimc_unregister_driver();
+}
+
+module_init(fimc_md_init);
+module_exit(fimc_md_exit);
+
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_DESCRIPTION("S5P FIMC camera host interface/video postprocessor driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("2.0.1");
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
new file mode 100644
index 0000000..7f39b5a
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -0,0 +1,118 @@
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
+ * @host: fimc device the sensor is currently linked to
+ * @clk_on: sclk_cam clock's state associated with this subdev
+ *
+ * This data structure applies to image sensor and the writeback subdevs.
+ */
+struct fimc_sensor_info {
+	struct s5p_fimc_isp_info *pdata;
+	struct v4l2_subdev *subdev;
+	struct fimc_dev *host;
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
+ * @vid_dev_compat: 1 if subdevs are configured by the host driver
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
+	int vid_dev_compat;
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
+int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
+void fimc_pipeline_prepare(struct fimc_dev *fimc, struct media_entity *me);
+int fimc_pipeline_initialize(struct fimc_dev *fimc, struct media_entity *me,
+			     bool resume);
+int fimc_pipeline_shutdown(struct fimc_dev *fimc);
+int fimc_pipeline_s_power(struct fimc_dev *fimc, int state);
+int fimc_pipeline_s_stream(struct fimc_dev *fimc, int state);
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

